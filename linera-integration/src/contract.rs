#![cfg_attr(target_arch = "wasm32", no_main)]

mod state;

use linera_sdk::{
    abi::WithContractAbi,
    base::Owner,
    Contract, ContractRuntime,
};
use smart_contract_2_linera::{
    AdaptiveContract, AIPrediction, Event, Operation, SmartContract2Abi,
};
use state::SmartContract2State;
use thiserror::Error;

pub struct SmartContract2;

#[derive(Debug, Error)]
pub enum ContractError {
    #[error("Unauthorized: Only owner can perform this action")]
    Unauthorized,
    
    #[error("Oracle not authorized")]
    OracleNotAuthorized,
    
    #[error("Contract not found")]
    ContractNotFound,
    
    #[error("Contract not active")]
    ContractNotActive,
    
    #[error("Invalid confidence value (must be 0-100)")]
    InvalidConfidence,
    
    #[error("View error: {0}")]
    ViewError(#[from] linera_views::views::ViewError),
}

linera_sdk::contract!(SmartContract2);

impl WithContractAbi for SmartContract2 {
    type Abi = SmartContract2Abi;
}

impl Contract for SmartContract2 {
    type Message = ();
    type Parameters = ();
    type InstantiationArgument = Owner;

    async fn load(runtime: ContractRuntime<Self>) -> Self {
        SmartContract2
    }

    async fn instantiate(&mut self, owner: Owner) {
        let mut state = SmartContract2State::load(self.runtime.root_view_storage_context())
            .await
            .expect("Failed to load state");
        
        state.initialize(owner.to_string()).await;
    }

    async fn execute_operation(&mut self, operation: Operation) -> Result<(), ContractError> {
        let mut state = SmartContract2State::load(self.runtime.root_view_storage_context())
            .await?;
        
        match operation {
            Operation::CreateAdaptiveContract {
                contract_type,
                threshold,
            } => {
                self.create_adaptive_contract(&mut state, contract_type, threshold).await?;
            }
            
            Operation::SubmitAIPrediction {
                contract_id,
                prediction_type,
                value,
                confidence,
            } => {
                self.submit_ai_prediction(
                    &mut state,
                    contract_id,
                    prediction_type,
                    value,
                    confidence,
                )
                .await?;
            }
            
            Operation::AuthorizeOracle { oracle_address } => {
                self.authorize_oracle(&mut state, oracle_address).await?;
            }
        }
        
        Ok(())
    }

    async fn execute_message(&mut self, _message: ()) {
        // No cross-chain messages for now
    }

    async fn store(mut self) {
        self.runtime.finalize().await;
    }
}

impl SmartContract2 {
    /// Create a new adaptive contract
    async fn create_adaptive_contract(
        &mut self,
        state: &mut SmartContract2State,
        contract_type: String,
        threshold: u64,
    ) -> Result<(), ContractError> {
        let creator = self.runtime
            .authenticated_signer()
            .ok_or(ContractError::Unauthorized)?;
        
        let contract_id = state.next_contract_id().await;
        let timestamp = self.runtime.system_time().micros();
        
        let contract = AdaptiveContract {
            id: contract_id,
            creator: creator.to_string(),
            contract_type: contract_type.clone(),
            threshold,
            is_active: true,
            created_at: timestamp,
            last_updated: timestamp,
        };
        
        state.contracts.insert(&contract_id, contract)?;
        
        // Emit event
        self.runtime.emit(Event::ContractCreated {
            contract_id,
            creator: creator.to_string(),
            contract_type,
        });
        
        Ok(())
    }
    
    /// Submit AI prediction from oracle
    async fn submit_ai_prediction(
        &mut self,
        state: &mut SmartContract2State,
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    ) -> Result<(), ContractError> {
        // Verify oracle authorization
        let oracle = self.runtime
            .authenticated_signer()
            .ok_or(ContractError::Unauthorized)?;
        
        if !state.is_oracle_authorized(&oracle.to_string()).await {
            return Err(ContractError::OracleNotAuthorized);
        }
        
        // Verify confidence range
        if confidence > 100 {
            return Err(ContractError::InvalidConfidence);
        }
        
        // Get contract and verify it's active
        let mut contract = state.contracts
            .get(&contract_id)
            .await?
            .ok_or(ContractError::ContractNotFound)?;
        
        if !contract.is_active {
            return Err(ContractError::ContractNotActive);
        }
        
        // Create prediction
        let timestamp = self.runtime.system_time().micros();
        let prediction = AIPrediction {
            timestamp,
            prediction_type: prediction_type.clone(),
            value,
            confidence,
            oracle: oracle.to_string(),
        };
        
        // Store prediction
        state.add_prediction(contract_id, prediction).await;
        
        // Update contract timestamp
        contract.last_updated = timestamp;
        state.contracts.insert(&contract_id, contract.clone())?;
        
        // Emit event
        self.runtime.emit(Event::PredictionReceived {
            contract_id,
            prediction_type: prediction_type.clone(),
            value,
            confidence,
        });
        
        // Check threshold and auto-execute
        self.check_and_execute(state, contract_id, value).await?;
        
        Ok(())
    }
    
    /// Authorize an oracle
    async fn authorize_oracle(
        &mut self,
        state: &mut SmartContract2State,
        oracle_address: String,
    ) -> Result<(), ContractError> {
        // Only owner can authorize oracles
        let caller = self.runtime
            .authenticated_signer()
            .ok_or(ContractError::Unauthorized)?;
        
        let owner = state.owner.get();
        if caller.to_string() != owner {
            return Err(ContractError::Unauthorized);
        }
        
        state.authorized_oracles.insert(&oracle_address, true)?;
        
        // Emit event
        self.runtime.emit(Event::OracleAuthorized {
            oracle: oracle_address,
        });
        
        Ok(())
    }
    
    /// Check threshold and auto-execute if needed
    async fn check_and_execute(
        &mut self,
        state: &mut SmartContract2State,
        contract_id: u64,
        value: i64,
    ) -> Result<(), ContractError> {
        let mut contract = state.contracts
            .get(&contract_id)
            .await?
            .ok_or(ContractError::ContractNotFound)?;
        
        if !contract.is_active {
            return Ok(());
        }
        
        // Check if value exceeds threshold
        let abs_value = value.abs() as u64;
        if abs_value >= contract.threshold {
            contract.is_active = false;
            state.contracts.insert(&contract_id, contract)?;
            
            // Emit execution event
            self.runtime.emit(Event::ContractExecuted {
                contract_id,
                reason: format!("Threshold reached: {} >= {}", abs_value, contract.threshold),
            });
        }
        
        Ok(())
    }
}
