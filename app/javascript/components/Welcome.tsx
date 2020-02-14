import React, { useState } from "react";
import ClaimEventForm from "./ClaimEventForm";
import ClaimEvent from "./ClaimEvent";
import axios from "axios";
import { Container, Row, Col } from "react-bootstrap";
import CKbIcon from "../images/ckb-n.png";

const Welcome: React.FC<WelcomeProps> = ({ claimEvents, officialAccount }) => {
  const [state, setState] = useState({
    claimEvents: claimEvents,
    address_hash: "",
    formError: "",
    officialAccount: {
      address_hash: officialAccount.address_hash,
      balance: officialAccount.balance
    }
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
    const form = event.currentTarget;
    const addressInput = form.elements[0] as HTMLInputElement;
    if (addressInput.value === "" && addressInput.value.trim().length < 40) {
      setState({ ...state, formError: "Address is invalid." });
      event.preventDefault();
      event.stopPropagation();
      return;
    }

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
        setState({ ...state, formError: "" });
      })
      .catch(error => {
        setState({
          ...state,
          formError: error.response.data["address_hash"][0]
        });
      });

    event.preventDefault();
  };

  return (
    <React.Fragment>
      <Container className="form-container" fluid>
        <Row className="justify-content-center align-items-center">
          <Col
            xs="12"
            md="8"
            lg="6"
            xl="4"
            className="align-self-center justify-content-center img-container"
          >
            <img src={CKbIcon} alt="" />
          </Col>
        </Row>
        <Row className="justify-content-center align-items-center">
          <Col
            xs="12"
            md="8"
            lg="6"
            xl="4"
            className="justify-content-center content-container"
          >
            <h1>Nervos Aggron Faucet</h1>
          </Col>
        </Row>
        <Row className="justify-content-center align-items-center">
          <Col
            xs="12"
            md="8"
            lg="6"
            xl="4"
            className="justify-content-center content-container"
          >
            <p>Claim testnet 50000 CKB from the faucet once every 8 hours</p>
          </Col>
        </Row>
        <Row className="justify-content-center align-items-center">
          <Col
            xs="12"
            md="8"
            lg="6"
            xl="4"
            className=" justify-content-center align-self-center"
          >
            <ClaimEventForm
              address_hash={state.address_hash}
              handleInput={handleInput}
              handleSubmit={handleSubmit}
              formError={state.formError}
            ></ClaimEventForm>
          </Col>
        </Row>
        <Row className="justify-content-center align-items-center">
          <Col
            xs="12"
            md="8"
            lg="6"
            xl="4"
            className="justify-content-center content-container"
          >
            <p>
              Faucet address balance is{" "}
              {Number(officialAccount.balance).toLocaleString("en")}
              &nbsp; CKB
            </p>
          </Col>
        </Row>
      </Container>
      <ClaimEvent claimEvents={claimEvents}></ClaimEvent>
    </React.Fragment>
  );
};

export default Welcome;
