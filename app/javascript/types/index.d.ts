declare namespace State {
  export interface Response {
    data: Array<ResponseData>;
  }

  export interface ResponseData {
    id: string;
    type: string;
    attributes: ClaimEventPresenter;
  }
  export interface ClaimEventPresenter {
    id: string;
    txHash: string;
    timestamp: string;
    addressHash: string;
    status: string;
    txStatus: string;
    capacity: string;
    fee: string;
  }

  export interface Account {
    addressHash: string;
    balance: string;
  }

  export interface WelcomeProps {
    claimEvents: Response;
    addressHash: string;
    officialAccount: Account;
    aggronExplorerHost: string;
  }

  export interface ClaimEventListProps {
    claimEvents: Array<ClaimEventPresenter>;
    aggronExplorerHost: string;
  }

  export interface ClaimEventProps {
    claimEvent: ClaimEventPresenter;
  }
}
declare module "*.png" {
  const value: any;
  export = value;
}

import ClaimEventPresenter = State.ClaimEventPresenter;
import ClaimEventListProps = State.ClaimEventListProps;
import ClaimEventProps = State.ClaimEventProps;
import WelcomeProps = State.WelcomeProps;
