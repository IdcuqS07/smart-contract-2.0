use async_graphql::{Request, Response, SimpleObject};
use linera_sdk::base::{ContractAbi, ServiceAbi};
use serde::{Deserialize, Serialize};

pub struct SmartContract2Abi;

impl ContractAbi for SmartContract2Abi {
    type Operation = Operation;
    type Response = ();
}

impl ServiceAbi for SmartContract2Abi {
    type Query = Request;
    type QueryResponse = Response;
}

/// Operations that can be executed on the smart contract
#[derive(Debug, Deserialize, Serialize)]
pub enum Operation {
    /// Create a new adaptive contract
    CreateAdaptiveContract {
        contract_type: String,
        threshold: u64,
    },
    /// Submit AI prediction from oracle
    SubmitAIPrediction {
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    },
    /// Authorize an oracle
    AuthorizeOracle {
        oracle_address: String,
    },
}

/// AI Prediction data structure
#[derive(Clone, Debug, Deserialize, Serialize, SimpleObject)]
pub struct AIPrediction {
    pub timestamp: u64,
    pub prediction_type: String,
    pub value: i64,
    pub confidence: u8,
    pub oracle: String,
}

/// Adaptive Contract data structure
#[derive(Clone, Debug, Deserialize, Serialize, SimpleObject)]
pub struct AdaptiveContract {
    pub id: u64,
    pub creator: String,
    pub contract_type: String,
    pub threshold: u64,
    pub is_active: bool,
    pub created_at: u64,
    pub last_updated: u64,
}

/// Events emitted by the contract
#[derive(Debug, Deserialize, Serialize)]
pub enum Event {
    ContractCreated {
        contract_id: u64,
        creator: String,
        contract_type: String,
    },
    PredictionReceived {
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    },
    ContractExecuted {
        contract_id: u64,
        reason: String,
    },
    OracleAuthorized {
        oracle: String,
    },
}
