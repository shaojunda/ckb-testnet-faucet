declare namespace State {
  export interface ClaimEventPresenter {
    tx_hash: string;
    timestamp: string;
    address_hash: string;
    status: string;
    capacity: string;
    fee: string;
  }

  export interface WelcomeProps {
    claimEvents: Array<ClaimEventPresenter>;
    address_hash: string;
  }
}

import ClaimEventPresenter = State.ClaimEventPresenter
import WelcomeProps = State.WelcomeProps
