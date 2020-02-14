import React from "react";

interface ClaimEventProps {
  claimEvents: Array<ClaimEventPresenter>;
}

const ClaimEvent: React.FC<ClaimEventProps> = props => {
  return <div>{props.claimEvents}</div>;
};

export default ClaimEvent;
