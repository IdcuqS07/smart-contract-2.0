use linera_sdk::views::{linera_views, MapView, RegisterView, RootView, ViewStorageContext};
use crate::{AdaptiveContract, AIPrediction};

#[derive(RootView)]
#[view(context = ViewStorageContext)]
pub struct SmartContract2State {
    pub contract_counter: RegisterView<u64>,
    pub contracts: MapView<u64, AdaptiveContract>,
    pub predictions: MapView<u64, Vec<AIPrediction>>,
    pub authorized_oracles: MapView<String, bool>,
    pub owner: RegisterView<String>,
}

impl SmartContract2State {
    pub fn initialize(&mut self, owner: String) {
        self.owner.set(owner);
        self.contract_counter.set(0);
    }
    
    pub async fn is_oracle_authorized(&self, oracle: &str) -> bool {
        self.authorized_oracles
            .get(oracle)
            .await
            .ok()
            .flatten()
            .unwrap_or(false)
    }
    
    pub fn next_contract_id(&mut self) -> u64 {
        let current = *self.contract_counter.get();
        let next = current + 1;
        self.contract_counter.set(next);
        next
    }
    
    pub async fn add_prediction(&mut self, contract_id: u64, prediction: AIPrediction) {
        let mut predictions = self.predictions
            .get(&contract_id)
            .await
            .ok()
            .flatten()
            .unwrap_or_default();
        
        predictions.push(prediction);
        let _ = self.predictions.insert(&contract_id, predictions);
    }
    
    pub async fn get_latest_prediction(&self, contract_id: u64) -> Option<AIPrediction> {
        let predictions = self.predictions
            .get(&contract_id)
            .await
            .ok()??;
        
        predictions.last().cloned()
    }
    
    pub async fn get_predictions(&self, contract_id: u64) -> Vec<AIPrediction> {
        self.predictions
            .get(&contract_id)
            .await
            .ok()
            .flatten()
            .unwrap_or_default()
    }
}
