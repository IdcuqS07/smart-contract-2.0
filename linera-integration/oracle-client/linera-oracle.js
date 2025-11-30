/**
 * Linera Oracle Client for Smart Contract 2.0
 * Connects AI Engine with Linera blockchain
 */

const { GraphQLClient, gql } = require('graphql-request');
const axios = require('axios');

class LineraOracleClient {
  constructor(config) {
    this.graphqlEndpoint = config.graphqlEndpoint || 'http://localhost:8080/graphql';
    this.chainId = config.chainId;
    this.applicationId = config.applicationId;
    this.ownerAddress = config.ownerAddress;
    this.aiEngineUrl = config.aiEngineUrl || 'http://localhost:5001';
    
    this.client = new GraphQLClient(this.graphqlEndpoint);
  }

  /**
   * Create a new adaptive contract on Linera
   */
  async createAdaptiveContract(contractType, threshold) {
    const mutation = gql`
      mutation CreateContract(
        $chainId: ChainId!,
        $applicationId: ApplicationId!,
        $contractType: String!,
        $threshold: Int!
      ) {
        executeOperation(
          chainId: $chainId,
          applicationId: $applicationId,
          operation: {
            CreateAdaptiveContract: {
              contract_type: $contractType,
              threshold: $threshold
            }
          }
        ) {
          hash
          outcome {
            events {
              ... on ContractCreated {
                contract_id
                creator
                contract_type
              }
            }
          }
        }
      }
    `;

    const variables = {
      chainId: this.chainId,
      applicationId: this.applicationId,
      contractType,
      threshold
    };

    try {
      const result = await this.client.request(mutation, variables);
      console.log('✅ Contract created:', result);
      
      // Extract contract ID from events
      const event = result.executeOperation.outcome.events.find(
        e => e.__typename === 'ContractCreated'
      );
      
      return {
        success: true,
        contractId: event?.contract_id,
        hash: result.executeOperation.hash
      };
    } catch (error) {
      console.error('❌ Error creating contract:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Request AI prediction and submit to Linera
   */
  async requestAndSubmitPrediction(contractId, modelType, data) {
    try {
      // Step 1: Request prediction from AI Engine
      console.log(`🤖 Requesting ${modelType} prediction...`);
      const aiResponse = await axios.post(`${this.aiEngineUrl}/predict`, {
        model_type: modelType,
        data: data || {}
      });

      const prediction = aiResponse.data;
      console.log('✅ AI Prediction received:', prediction);

      // Step 2: Extract value based on model type
      let value = 0;
      if (prediction.prediction !== undefined) {
        value = Math.floor(prediction.prediction);
      } else if (prediction.risk_score !== undefined) {
        value = prediction.risk_score;
      } else if (prediction.fraud_score !== undefined) {
        value = prediction.fraud_score;
      }

      // Step 3: Submit to Linera blockchain
      console.log(`📤 Submitting to Linera blockchain...`);
      const submitResult = await this.submitAIPrediction(
        contractId,
        modelType,
        value,
        prediction.confidence
      );

      return {
        success: true,
        prediction,
        blockchain: submitResult
      };
    } catch (error) {
      console.error('❌ Error in prediction flow:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Submit AI prediction to Linera blockchain
   */
  async submitAIPrediction(contractId, predictionType, value, confidence) {
    const mutation = gql`
      mutation SubmitPrediction(
        $chainId: ChainId!,
        $applicationId: ApplicationId!,
        $contractId: Int!,
        $predictionType: String!,
        $value: Int!,
        $confidence: Int!
      ) {
        executeOperation(
          chainId: $chainId,
          applicationId: $applicationId,
          operation: {
            SubmitAIPrediction: {
              contract_id: $contractId,
              prediction_type: $predictionType,
              value: $value,
              confidence: $confidence
            }
          }
        ) {
          hash
          outcome {
            events {
              ... on PredictionReceived {
                contract_id
                prediction_type
                value
                confidence
              }
              ... on ContractExecuted {
                contract_id
                reason
              }
            }
          }
        }
      }
    `;

    const variables = {
      chainId: this.chainId,
      applicationId: this.applicationId,
      contractId,
      predictionType,
      value,
      confidence
    };

    try {
      const result = await this.client.request(mutation, variables);
      console.log('✅ Prediction submitted to blockchain:', result);
      
      return {
        success: true,
        hash: result.executeOperation.hash,
        events: result.executeOperation.outcome.events
      };
    } catch (error) {
      console.error('❌ Error submitting prediction:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Query contract information
   */
  async getContract(contractId) {
    const query = gql`
      query GetContract($chainId: ChainId!, $applicationId: ApplicationId!, $contractId: Int!) {
        application(chainId: $chainId, id: $applicationId) {
          contract(id: $contractId) {
            id
            creator
            contract_type
            threshold
            is_active
            created_at
            last_updated
          }
        }
      }
    `;

    const variables = {
      chainId: this.chainId,
      applicationId: this.applicationId,
      contractId
    };

    try {
      const result = await this.client.request(query, variables);
      return result.application.contract;
    } catch (error) {
      console.error('❌ Error querying contract:', error);
      return null;
    }
  }

  /**
   * Query latest prediction for a contract
   */
  async getLatestPrediction(contractId) {
    const query = gql`
      query GetLatestPrediction($chainId: ChainId!, $applicationId: ApplicationId!, $contractId: Int!) {
        application(chainId: $chainId, id: $applicationId) {
          latest_prediction(contract_id: $contractId) {
            timestamp
            prediction_type
            value
            confidence
            oracle
          }
        }
      }
    `;

    const variables = {
      chainId: this.chainId,
      applicationId: this.applicationId,
      contractId
    };

    try {
      const result = await this.client.request(query, variables);
      return result.application.latest_prediction;
    } catch (error) {
      console.error('❌ Error querying prediction:', error);
      return null;
    }
  }

  /**
   * Subscribe to real-time events
   */
  subscribeToEvents(callback) {
    const subscription = gql`
      subscription ContractEvents($chainId: ChainId!) {
        notifications(chainId: $chainId) {
          reason {
            ... on ExecutedBlock {
              outcome {
                events {
                  ... on ContractCreated {
                    contract_id
                    creator
                    contract_type
                  }
                  ... on PredictionReceived {
                    contract_id
                    prediction_type
                    value
                    confidence
                  }
                  ... on ContractExecuted {
                    contract_id
                    reason
                  }
                }
              }
            }
          }
        }
      }
    `;

    // WebSocket subscription (implementation depends on GraphQL client)
    console.log('📡 Subscribing to Linera events...');
    // TODO: Implement WebSocket subscription
    return { unsubscribe: () => console.log('Unsubscribed') };
  }

  /**
   * Authorize an oracle address
   */
  async authorizeOracle(oracleAddress) {
    const mutation = gql`
      mutation AuthorizeOracle(
        $chainId: ChainId!,
        $applicationId: ApplicationId!,
        $oracleAddress: String!
      ) {
        executeOperation(
          chainId: $chainId,
          applicationId: $applicationId,
          operation: {
            AuthorizeOracle: {
              oracle_address: $oracleAddress
            }
          }
        ) {
          hash
          outcome {
            events {
              ... on OracleAuthorized {
                oracle
              }
            }
          }
        }
      }
    `;

    const variables = {
      chainId: this.chainId,
      applicationId: this.applicationId,
      oracleAddress
    };

    try {
      const result = await this.client.request(mutation, variables);
      console.log('✅ Oracle authorized:', result);
      return { success: true, hash: result.executeOperation.hash };
    } catch (error) {
      console.error('❌ Error authorizing oracle:', error);
      return { success: false, error: error.message };
    }
  }
}

module.exports = LineraOracleClient;
