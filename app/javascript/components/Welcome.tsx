import React, { useState, useEffect, useRef } from "react";
import ClaimEventForm from "./ClaimEventForm";
import ClaimEventList from "./ClaimEventList";
import axios from "axios";
import { Container, Row, Col } from "react-bootstrap";
import CKbIcon from "../images/ckb-n.png";
import { context } from "../utils/util";

const Welcome: React.FC<WelcomeProps> = ({
  claimEvents,
  officialAccount,
  aggronExplorerHost
}) => {
  const addressHash = useRef("");
  const [state, setState] = useState({
    claimEvents: claimEvents.data.map(event => {
      return event.attributes;
    }),
    formError: "",
    officialAccount: {
      addressHash: officialAccount.addressHash,
      balance: officialAccount.balance
    }
  });

  useEffect(() => {
    const timer = setInterval(() => {
      axios({
        method: "GET",
        url: "/claim_events"
      })
        .then(response => {
          setState({
            ...state,
            officialAccount: response.data.official_account,
            claimEvents: response.data.claimEvents.data.map(
              (event: ResponseData) => {
                return event.attributes;
              }
            )
          });
        })
        .catch(error => {});
    }, 5000);

    return () => {
      clearInterval(timer);
    };
  }, [state.claimEvents]);

  const addNewEvent = (claimEvent: ClaimEventPresenter) => {
    const claimEvents = [claimEvent, ...state.claimEvents].sort((a, b) => {
      return +new Date(b.timestamp) - +new Date(a.timestamp);
    });
    setState({
      ...state,
      claimEvents: claimEvents
    });
  };

  const handleInput: React.ChangeEventHandler<HTMLInputElement> = (
    event: React.FormEvent<HTMLInputElement>
  ) => {
    const target = event.target as HTMLInputElement;
    addressHash.current = target.value;
    setState({
      ...state,
      formError: ""
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
      data: { claim_event: { address_hash: addressHash.current } },
      headers: {
        "X-CSRF-Token": csrfToken
      }
    })
      .then(response => {
        addNewEvent(response.data.data.attributes);
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
    <context.Provider value={aggronExplorerHost}>
      <React.Fragment>
        <Container className="form-container" fluid>
          <Row className="justify-content-center align-items-center">
            <Col
              xs="10"
              md="8"
              lg="6"
              xl="5"
              className="align-self-center justify-content-center img-container"
            >
              <img src={CKbIcon} alt="" />
            </Col>
          </Row>
          <Row className="justify-content-center align-items-center">
            <Col
              xs="11"
              md="8"
              lg="6"
              xl="5"
              className="justify-content-center content-container"
            >
              <h1>Nervos Aggron Faucet</h1>
            </Col>
          </Row>
          <Row className="justify-content-center align-items-center">
            <Col
              xs="10"
              md="8"
              lg="6"
              xl="5"
              className="justify-content-center content-container"
            >
              <p>Claim testnet 50000 CKB from the faucet once every 8 hours</p>
            </Col>
          </Row>
          <Row className="justify-content-center align-items-center">
            <Col
              xs="10"
              md="8"
              lg="6"
              xl="4"
              className=" justify-content-center align-self-center"
            >
              <ClaimEventForm
                addressHash={addressHash.current}
                handleInput={handleInput}
                handleSubmit={handleSubmit}
                formError={state.formError}
              ></ClaimEventForm>
            </Col>
          </Row>
          <Row className="justify-content-center align-items-center">
            <Col
              xs="10"
              md="8"
              lg="6"
              xl="5"
              className="justify-content-center content-container"
            >
              <p>
                Faucet address balance is{" "}
                {Number(state.officialAccount.balance).toLocaleString("en")}
                &nbsp; CKB
              </p>
            </Col>
          </Row>
        </Container>
        <Container className="claim-event-list-container">
          {state.claimEvents.length > 0 ? (
            <Row className="justify-content-center align-items-center">
              <Col xs="12" md="12" lg="10" xl="10">
                <h2>Claims</h2>
              </Col>
            </Row>
          ) : (
            ""
          )}
          <Row className="justify-content-center align-items-center">
            <Col xs="12" md="12" lg="10" xl="10">
              {state.claimEvents.length == 0 ? (
                <div className="justify-content-center align-items-center empty-records d-flex">
                  <h1>No Claim Yet</h1>
                </div>
              ) : (
                <ClaimEventList
                  claimEvents={state.claimEvents}
                  aggronExplorerHost={aggronExplorerHost}
                ></ClaimEventList>
              )}
            </Col>
          </Row>
        </Container>
      </React.Fragment>
    </context.Provider>
  );
};

export default Welcome;
