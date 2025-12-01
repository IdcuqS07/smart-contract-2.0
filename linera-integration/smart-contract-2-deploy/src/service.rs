#![cfg_attr(target_arch = "wasm32", no_main)]

mod state;

use std::sync::Arc;

use async_graphql::{EmptySubscription, Object, Schema};
use linera_sdk::{
    graphql::GraphQLMutationRoot, linera_base_types::WithServiceAbi, views::View, Service,
    ServiceRuntime,
};

use smart_contract_2_deploy::Operation;

use self::state::SmartContract2DeployState;

pub struct SmartContract2DeployService {
    state: SmartContract2DeployState,
    runtime: Arc<ServiceRuntime<Self>>,
}

linera_sdk::service!(SmartContract2DeployService);

impl WithServiceAbi for SmartContract2DeployService {
    type Abi = smart_contract_2_deploy::SmartContract2DeployAbi;
}

impl Service for SmartContract2DeployService {
    type Parameters = ();

    async fn new(runtime: ServiceRuntime<Self>) -> Self {
        let state = SmartContract2DeployState::load(runtime.root_view_storage_context())
            .await
            .expect("Failed to load state");
        SmartContract2DeployService {
            state,
            runtime: Arc::new(runtime),
        }
    }

    async fn handle_query(&self, query: Self::Query) -> Self::QueryResponse {
        Schema::build(
            QueryRoot {
                value: *self.state.value.get(),
            },
            Operation::mutation_root(self.runtime.clone()),
            EmptySubscription,
        )
        .finish()
        .execute(query)
        .await
    }
}

struct QueryRoot {
    value: u64,
}

#[Object]
impl QueryRoot {
    async fn value(&self) -> &u64 {
        &self.value
    }
}

#[cfg(test)]
mod tests {
    use std::sync::Arc;

    use async_graphql::{Request, Response, Value};
    use futures::FutureExt as _;
    use linera_sdk::{util::BlockingWait, views::View, Service, ServiceRuntime};
    use serde_json::json;

    use super::{SmartContract2DeployService, SmartContract2DeployState};

    #[test]
    fn query() {
        let value = 60u64;
        let runtime = Arc::new(ServiceRuntime::<SmartContract2DeployService>::new());
        let mut state = SmartContract2DeployState::load(runtime.root_view_storage_context())
            .blocking_wait()
            .expect("Failed to read from mock key value store");
        state.value.set(value);

        let service = SmartContract2DeployService { state, runtime };
        let request = Request::new("{ value }");

        let response = service
            .handle_query(request)
            .now_or_never()
            .expect("Query should not await anything");

        let expected = Response::new(Value::from_json(json!({"value": 60})).unwrap());

        assert_eq!(response, expected)
    }
}
