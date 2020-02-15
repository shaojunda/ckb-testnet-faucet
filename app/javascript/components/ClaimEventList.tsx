import React from "react";
import ClaimEvent from "./ClaimEvent";

const ClaimEventList: React.FC<ClaimEventListProps> = ({ claimEvents }) => {
  return (
    <React.Fragment>
      {claimEvents.map(event => {
        return <ClaimEvent key={event.id} claimEvent={event}></ClaimEvent>;
      })}
    </React.Fragment>
  );
};

export default ClaimEventList;
