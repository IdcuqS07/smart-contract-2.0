#![cfg_attr(target_arch = "wasm32", no_main)]

mod state;

use std::sync::Arc;

use async_graphql::{EmptySubscription, Object, Request, Response, Schema};
use linera_sdk::{
    linera_base_types::WithServiceAbi,
    views::View,
    Service, ServiceRuntime,
};
use smart_contract_2_linera::{AdaptiveContract, AIPrediction, Operation, SmartContract2Abi};
use state::SmartContract2State;

pub struct SmartContract2Service {
    state: Arc<SmartContract2State>,
    runtime: Arc<ServiceRuntime<Self>>,
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
            runtime: Arc::new(runtime),
        }
    }

    async fn handle_query(&self, request: Request) -> Response {
        let schema = Schema::build(
            QueryRoot {
                state: self.state.clone(),
            },
            MutationRoot {
                runtime: self.runtime.clone(),
            },
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
    async fn contract(&self, id: u64) -> Option<AdaptiveContract> {
        self.state.contracts.get(&id).await.ok().flatten()
    }
    
    async fn contracts(&self) -> Vec<AdaptiveContract> {
        let mut contracts = Vec::new();
        let counter = *self.state.contract_counter.get();
        
        for id in 1..=counter {
            if let Ok(Some(contract)) = self.state.contracts.get(&id).await {
                contracts.push(contract);
            }
        }
        
        contracts
    }
    
    async fn latest_prediction(&self, contract_id: u64) -> Option<AIPrediction> {
        self.state.get_latest_prediction(contract_id).await
    }
    
    async fn predictions(&self, contract_id: u64) -> Vec<AIPrediction> {
        self.state
            .predictions
            .get(&contract_id)
            .await
            .ok()
            .flatten()
            .unwrap_or_default()
    }
    
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
    
    async fn is_oracle_authorized(&self, oracle: String) -> bool {
        self.state.is_oracle_authorized(&oracle).await
    }
    
    async fn contract_counter(&self) -> u64 {
        *self.state.contract_counter.get()
    }
    
    async fn owner(&self) -> String {
        self.state.owner.get().clone()
    }
}

struct MutationRoot {
    runtime: Arc<ServiceRuntime<SmartContract2Service>>,
}

#[Object]
impl MutationRoot {
    async fn create_contract(&self, contract_type: String, threshold: u64) -> [u8; 0] {
        let operation = Operation::CreateAdaptiveContract {
            contract_type,
            threshold,
        };
        self.runtime.schedule_operation(&operation);
        []
    }
    
    async fn submit_prediction(
        &self,
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    ) -> [u8; 0] {
        let operation = Operation::SubmitAIPrediction {
            contract_id,
            prediction_type,
            value,
            confidence,
        };
        self.runtime.schedule_operation(&operation);
        []
    }
    
    async fn authorize_oracle(&self, oracle_address: String) -> [u8; 0] {
        let operation = Operation::AuthorizeOracle { oracle_address };
        self.runtime.schedule_operation(&operation);
        []
    }
}
