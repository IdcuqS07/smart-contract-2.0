#![cfg_attr(target_arch = "wasm32", no_main)]

mod state;

use linera_sdk::{
    linera_base_types::WithContractAbi,
    views::{RootView, View},
    Contract, ContractRuntime,
};

use smart_contract_2_deploy::Operation;

use self::state::SmartContract2DeployState;

pub struct SmartContract2DeployContract {
    state: SmartContract2DeployState,
    runtime: ContractRuntime<Self>,
}

linera_sdk::contract!(SmartContract2DeployContract);

impl WithContractAbi for SmartContract2DeployContract {
    type Abi = smart_contract_2_deploy::SmartContract2DeployAbi;
}

impl Contract for SmartContract2DeployContract {
    type Message = ();
    type Parameters = ();
    type InstantiationArgument = u64;
    type EventValue = ();

    async fn load(runtime: ContractRuntime<Self>) -> Self {
        let state = SmartContract2DeployState::load(runtime.root_view_storage_context())
            .await
            .expect("Failed to load state");
        SmartContract2DeployContract { state, runtime }
    }

    async fn instantiate(&mut self, argument: Self::InstantiationArgument) {
        // validate that the application parameters were configured correctly.
        self.runtime.application_parameters();
        self.state.value.set(argument);
    }

    async fn execute_operation(&mut self, operation: Self::Operation) -> Self::Response {
        match operation {
            Operation::Increment { value } => {
                self.state.value.set(self.state.value.get() + value);
            }
        }
    }

    async fn execute_message(&mut self, _message: Self::Message) {}

    async fn store(mut self) {
        self.state.save().await.expect("Failed to save state");
    }
}

#[cfg(test)]
mod tests {
    use futures::FutureExt as _;
    use linera_sdk::{util::BlockingWait, views::View, Contract, ContractRuntime};

    use smart_contract_2_deploy::Operation;

    use super::{SmartContract2DeployContract, SmartContract2DeployState};

    #[test]
    fn operation() {
        let initial_value = 10u64;
        let mut app = create_and_instantiate_app(initial_value);

        let increment = 10u64;

        let _response = app
            .execute_operation(Operation::Increment { value: increment })
            .now_or_never()
            .expect("Execution of application operation should not await anything");

        assert_eq!(*app.state.value.get(), initial_value + increment);
    }

    fn create_and_instantiate_app(initial_value: u64) -> SmartContract2DeployContract {
        let runtime = ContractRuntime::new().with_application_parameters(());
        let mut contract = SmartContract2DeployContract {
            state: SmartContract2DeployState::load(runtime.root_view_storage_context())
                .blocking_wait()
                .expect("Failed to read from mock key value store"),
            runtime,
        };

        contract
            .instantiate(initial_value)
            .now_or_never()
            .expect("Initialization of application state should not await anything");

        assert_eq!(*contract.state.value.get(), initial_value);

        contract
    }
}
