import React, { useState } from "react";
import ClaimEventForm from "./ClaimEventForm";
import ClaimEvent from "./ClaimEvent";
import axios from "axios";

const Welcome: React.FC<WelcomeProps> = ({ claimEvents, address_hash }) => {
  const [state, setState] = useState({
    claimEvents: claimEvents,
    address_hash: address_hash
  });

  const handleInput: React.ChangeEventHandler<HTMLInputElement> = (
    event: React.FormEvent<HTMLInputElement>
  ) => {
    const target = event.target as HTMLInputElement;
    setState({
      ...state,
      address_hash: target.value
    });
    event.preventDefault();
  };

  const handleSubmit: React.FormEventHandler<HTMLFormElement> = (
    event: React.FormEvent<HTMLFormElement>
  ) => {
    const csrfObj: HTMLMetaElement | null = document.querySelector(
      "meta[name=csrf-token]"
    );
    const csrfToken = csrfObj ? csrfObj.content : "";
    axios({
      method: "POST",
      url: "/claim_events",
      data: { claim_event: { address_hash: state.address_hash } },
      headers: {
        "X-CSRF-Token": csrfToken
      }
    })
      .then(response => {
        console.log(response.data);
      })
      .catch(error => {
        console.log(error);
      });

    event.preventDefault();
  };

  return (
    <React.Fragment>
      {/* Header */}
      <ClaimEventForm
        address_hash={address_hash}
        handleInput={handleInput}
        handleSubmit={handleSubmit}
      ></ClaimEventForm>
      <ClaimEvent claimEvents={claimEvents}></ClaimEvent>
      {/* Footer */}
    </React.Fragment>
  );
};

export default Welcome;
