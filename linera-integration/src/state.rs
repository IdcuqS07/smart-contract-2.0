use linera_sdk::views::{MapView, RegisterView, RootView};
use crate::{AdaptiveContract, AIPrediction};

/// Application state stored on the blockchain
#[derive(RootView)]
pub struct SmartContract2State {
    /// Counter for contract IDs
    pub contract_counter: RegisterView<u64>,
    
    /// Map of contract ID to AdaptiveContract
    pub contracts: MapView<u64, AdaptiveContract>,
    
    /// Map of contract ID to list of predictions
    pub predictions: MapView<u64, Vec<AIPrediction>>,
    
    /// Set of authorized oracles
    pub authorized_oracles: MapView<String, bool>,
    
    /// Owner of the application
    pub owner: RegisterView<String>,
}

impl SmartContract2State {
    /// Initialize the state with an owner
    pub async fn initialize(&mut self, owner: String) {
        self.owner.set(owner);
        self.contract_counter.set(0);
    }
    
    /// Check if an oracle is authorized
    pub async fn is_oracle_authorized(&self, oracle: &str) -> bool {
        self.authorized_oracles
            .get(oracle)
            .await
            .unwrap_or(Ok(false))
            .unwrap_or(false)
    }
    
    /// Get the next contract ID
    pub async fn next_contract_id(&mut self) -> u64 {
        let current = self.contract_counter.get();
        let next = current + 1;
        self.contract_counter.set(next);
        next
    }
    
    /// Add a prediction to a contract
    pub async fn add_prediction(&mut self, contract_id: u64, prediction: AIPrediction) {
        let mut predictions = self.predictions
            .get(&contract_id)
            .await
            .unwrap_or(Ok(Vec::new()))
            .unwrap_or_default();
        
        predictions.push(prediction);
        self.predictions.insert(&contract_id, predictions).unwrap();
    }
    
    /// Get latest prediction for a contract
    pub async fn get_latest_prediction(&self, contract_id: u64) -> Option<AIPrediction> {
        let predictions = self.predictions
            .get(&contract_id)
            .await
            .ok()??;
        
        predictions.last().cloned()
    }
}
