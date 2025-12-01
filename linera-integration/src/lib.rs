#![cfg_attr(target_arch = "wasm32", no_main)]

mod state;

use linera_sdk::{
    abi::{ContractAbi, ServiceAbi, WithContractAbi, WithServiceAbi},
    views::{RootView, View},
    Contract, ContractRuntime, Service, ServiceRuntime,
};
use serde::{Deserialize, Serialize};
use state::SmartContract2State;

// ABI Definition
pub struct SmartContract2Abi;

impl ContractAbi for SmartContract2Abi {
    type Operation = Operation;
    type Response = ();
}

impl ServiceAbi for SmartContract2Abi {
    type Query = QueryRequest;
    type QueryResponse = QueryResponse;
}

// Operations
#[derive(Debug, Deserialize, Serialize)]
pub enum Operation {
    CreateAdaptiveContract {
        contract_type: String,
        threshold: u64,
    },
    SubmitAIPrediction {
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    },
    AuthorizeOracle {
        oracle_address: String,
    },
}

// Query types
#[derive(Debug, Deserialize, Serialize)]
pub enum QueryRequest {
    GetContract { id: u64 },
    GetAllContracts,
    GetPredictions { contract_id: u64 },
}

#[derive(Debug, Deserialize, Serialize)]
pub enum QueryResponse {
    Contract(Option<AdaptiveContract>),
    Contracts(Vec<AdaptiveContract>),
    Predictions(Vec<AIPrediction>),
}

// Data structures
#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct AIPrediction {
    pub timestamp: u64,
    pub prediction_type: String,
    pub value: i64,
    pub confidence: u8,
    pub oracle: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct AdaptiveContract {
    pub id: u64,
    pub creator: String,
    pub contract_type: String,
    pub threshold: u64,
    pub is_active: bool,
    pub created_at: u64,
    pub last_updated: u64,
}

// Contract Implementation
pub struct SmartContract2Contract {
    state: SmartContract2State,
    runtime: ContractRuntime<Self>,
}

impl WithContractAbi for SmartContract2Contract {
    type Abi = SmartContract2Abi;
}

linera_sdk::contract!(SmartContract2Contract);

impl Contract for SmartContract2Contract {
    type Message = ();
    type Parameters = ();
    type InstantiationArgument = String;
    type EventValue = ();

    async fn load(runtime: ContractRuntime<Self>) -> Self {
        let state = SmartContract2State::load(runtime.root_view_storage_context())
            .await
            .expect("Failed to load state");
        SmartContract2Contract { state, runtime }
    }

    async fn instantiate(&mut self, owner: String) {
        let _ = self.runtime.application_parameters();
        self.state.initialize(owner);
    }

    async fn execute_operation(&mut self, operation: Self::Operation) -> Self::Response {
        match operation {
            Operation::CreateAdaptiveContract { contract_type, threshold } => {
                self.create_adaptive_contract(contract_type, threshold).await;
            }
            Operation::SubmitAIPrediction { contract_id, prediction_type, value, confidence } => {
                self.submit_ai_prediction(contract_id, prediction_type, value, confidence).await;
            }
            Operation::AuthorizeOracle { oracle_address } => {
                self.authorize_oracle(oracle_address).await;
            }
        }
    }

    async fn execute_message(&mut self, _message: Self::Message) {
        // No cross-chain messages yet
    }

    async fn store(mut self) {
        self.state.save().await.expect("Failed to save state");
    }
}

impl SmartContract2Contract {
    async fn create_adaptive_contract(&mut self, contract_type: String, threshold: u64) {
        let creator = match self.runtime.authenticated_signer() {
            Some(signer) => signer.to_string(),
            None => return,
        };
        
        let contract_id = self.state.next_contract_id();
        let timestamp = self.runtime.system_time().micros();
        
        let contract = AdaptiveContract {
            id: contract_id,
            creator,
            contract_type,
            threshold,
            is_active: true,
            created_at: timestamp,
            last_updated: timestamp,
        };
        
        let _ = self.state.contracts.insert(&contract_id, contract);
    }
    
    async fn submit_ai_prediction(
        &mut self,
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    ) {
        let oracle = match self.runtime.authenticated_signer() {
            Some(signer) => signer.to_string(),
            None => return,
        };
        
        if !self.state.is_oracle_authorized(&oracle).await {
            return;
        }
        
        if confidence > 100 {
            return;
        }
        
        let mut contract = match self.state.contracts.get(&contract_id).await {
            Ok(Some(c)) => c,
            _ => return,
        };
        
        if !contract.is_active {
            return;
        }
        
        let timestamp = self.runtime.system_time().micros();
        let prediction = AIPrediction {
            timestamp,
            prediction_type,
            value,
            confidence,
            oracle,
        };
        
        self.state.add_prediction(contract_id, prediction).await;
        
        contract.last_updated = timestamp;
        let _ = self.state.contracts.insert(&contract_id, contract);
        
        self.check_and_execute(contract_id, value).await;
    }
    
    async fn authorize_oracle(&mut self, oracle_address: String) {
        let caller = match self.runtime.authenticated_signer() {
            Some(signer) => signer.to_string(),
            None => return,
        };
        
        let owner = self.state.owner.get().clone();
        if caller != owner {
            return;
        }
        
        let _ = self.state.authorized_oracles.insert(&oracle_address, true);
    }
    
    async fn check_and_execute(&mut self, contract_id: u64, value: i64) {
        let mut contract = match self.state.contracts.get(&contract_id).await {
            Ok(Some(c)) => c,
            _ => return,
        };
        
        if !contract.is_active {
            return;
        }
        
        let abs_value = value.abs() as u64;
        if abs_value >= contract.threshold {
            contract.is_active = false;
            let _ = self.state.contracts.insert(&contract_id, contract);
        }
    }
}

// Service Implementation
pub struct SmartContract2Service {
    state: SmartContract2State,
}

impl WithServiceAbi for SmartContract2Service {
    type Abi = SmartContract2Abi;
}

linera_sdk::service!(SmartContract2Service);

impl Service for SmartContract2Service {
    type Parameters = ();

    async fn new(runtime: ServiceRuntime<Self>) -> Self {
        let state = SmartContract2State::load(runtime.root_view_storage_context())
            .await
            .expect("Failed to load state");
        SmartContract2Service { state }
    }

    async fn handle_query(&self, request: Self::Query) -> Self::QueryResponse {
        match request {
            QueryRequest::GetContract { id } => {
                let contract = self.state.contracts.get(&id).await.ok().flatten();
                QueryResponse::Contract(contract)
            }
            QueryRequest::GetAllContracts => {
                let mut contracts = Vec::new();
                self.state
                    .contracts
                    .for_each_index_value(|_key, contract| {
                        contracts.push(contract.into_owned());
                        Ok(())
                    })
                    .await
                    .ok();
                QueryResponse::Contracts(contracts)
            }
            QueryRequest::GetPredictions { contract_id } => {
                let predictions = self.state.get_predictions(contract_id).await;
                QueryResponse::Predictions(predictions)
            }
        }
    }
}
