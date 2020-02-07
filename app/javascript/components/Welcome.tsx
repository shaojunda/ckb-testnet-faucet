import * as React from "react";
import ClaimEventForm from "./ClaimEventForm";
import ClaimEvent from "./ClaimEvent";

const Welcome: React.FC = () => {
  return (
    <React.Fragment>
      {/* Header */}
      <ClaimEventForm></ClaimEventForm>
      <ClaimEvent claimEvents={[]}></ClaimEvent>
      {/* Footer */}
    </React.Fragment>
  );
};

export default Welcome;
