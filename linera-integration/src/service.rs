#![cfg_attr(target_arch = "wasm32", no_main)]

mod state;

use async_graphql::{EmptySubscription, Object, Request, Response, Schema};
use linera_sdk::{
    abi::WithServiceAbi,
    Service, ServiceRuntime,
};
use smart_contract_2_linera::{AdaptiveContract, AIPrediction, SmartContract2Abi};
use state::SmartContract2State;
use std::sync::Arc;

pub struct SmartContract2Service {
    state: Arc<SmartContract2State>,
}

linera_sdk::service!(SmartContract2Service);

impl WithServiceAbi for SmartContract2Service {
    type Abi = SmartContract2Abi;
}

impl Service for SmartContract2Service {
    type Parameters = ();

    async fn new(runtime: ServiceRuntime<Self>) -> Self {
        let state = SmartContract2State::load(runtime.root_view_storage_context())
            .await
            .expect("Failed to load state");
        
        SmartContract2Service {
            state: Arc::new(state),
        }
    }

    async fn handle_query(&self, request: Request) -> Response {
        let schema = Schema::build(
            QueryRoot {
                state: self.state.clone(),
            },
            MutationRoot,
            EmptySubscription,
        )
        .finish();
        
        schema.execute(request).await
    }
}

struct QueryRoot {
    state: Arc<SmartContract2State>,
}

#[Object]
impl QueryRoot {
    /// Get contract by ID
    async fn contract(&self, id: u64) -> Option<AdaptiveContract> {
        self.state
            .contracts
            .get(&id)
            .await
            .ok()
            .flatten()
    }
    
    /// Get all contracts
    async fn contracts(&self) -> Vec<AdaptiveContract> {
        let mut contracts = Vec::new();
        let counter = self.state.contract_counter.get();
        
        for id in 1..=counter {
            if let Ok(Some(contract)) = self.state.contracts.get(&id).await {
                contracts.push(contract);
            }
        }
        
        contracts
    }
    
    /// Get latest prediction for a contract
    async fn latest_prediction(&self, contract_id: u64) -> Option<AIPrediction> {
        self.state.get_latest_prediction(contract_id).await
    }
    
    /// Get all predictions for a contract
    async fn predictions(&self, contract_id: u64) -> Vec<AIPrediction> {
        self.state
            .predictions
            .get(&contract_id)
            .await
            .ok()
            .flatten()
            .unwrap_or_default()
    }
    
    /// Get prediction count for a contract
    async fn prediction_count(&self, contract_id: u64) -> u64 {
        self.state
            .predictions
            .get(&contract_id)
            .await
            .ok()
            .flatten()
            .map(|p| p.len() as u64)
            .unwrap_or(0)
    }
    
    /// Check if oracle is authorized
    async fn is_oracle_authorized(&self, oracle: String) -> bool {
        self.state.is_oracle_authorized(&oracle).await
    }
    
    /// Get contract counter
    async fn contract_counter(&self) -> u64 {
        self.state.contract_counter.get()
    }
}

struct MutationRoot;

#[Object]
impl MutationRoot {
    /// Placeholder for mutations (handled by contract operations)
    async fn placeholder(&self) -> bool {
        true
    }
}
