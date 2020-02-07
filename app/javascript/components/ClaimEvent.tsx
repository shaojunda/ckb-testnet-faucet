import React from "react";

interface ClaimEventPresenter {
  tx_hash: string;
  timestamp: string;
  address_hash: string;
  status: string;
  capacity: string;
  fee: string;
}
interface ClaimEventProps {
  claimEvents: Array<ClaimEventPresenter>;
}

const ClaimEvent: React.FC<ClaimEventProps> = props => {
  return <div>{props.claimEvents}</div>;
};

export default ClaimEvent;
