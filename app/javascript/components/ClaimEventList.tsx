import React from "react";
import {
  Card,
  Container,
  Row,
  Col,
  Badge,
  Tooltip,
  OverlayTrigger
} from "react-bootstrap";
import { parseSimpleDate } from "../utils/util";

const ClaimEventList: React.FC<ClaimEventListProps> = ({
  claimEvents,
  aggronExplorerHost
}) => {
  const explorer_address_url = "https://explorer.nervos.org/aggron/address";
  const explorer_transaction_url =
    "https://explorer.nervos.org/aggron/transaction";

  return (
    <React.Fragment>
      {claimEvents.map(event => {
        console.log(event.txHash);
        return (
          <Card key={event.id}>
            <Card.Header>
              <Container>
                <Row>
                  <Col>
                    <span className="hash-letter">
                      {event.txHash === null ? (
                        "-"
                      ) : (
                        <a
                          href={
                            aggronExplorerHost + "/transaction/" + event.txHash
                          }
                          target="_blank"
                        >
                          {event.txHash}
                        </a>
                      )}
                    </span>
                  </Col>
                  <Col className="text-right">
                    <span className="pull-right timestamp">
                      {parseSimpleDate(event.timestamp)}
                    </span>
                  </Col>
                </Row>
              </Container>
            </Card.Header>
            <Card.Body>
              <Container>
                <Row>
                  <Col>
                    <span className="hash-letter">
                      <a
                        href={
                          aggronExplorerHost + "/address/" + event.addressHash
                        }
                        target="_blank"
                      >
                        {event.addressHash}
                      </a>
                    </span>
                  </Col>
                  <Col className="text-right">
                    <OverlayTrigger
                      overlay={
                        <Tooltip id={`tooltip-capacity`}>
                          Claimed capacity
                        </Tooltip>
                      }
                    >
                      <span className="has-tooltip">{event.capacity} CKB</span>
                    </OverlayTrigger>
                  </Col>
                </Row>
                <Row>
                  <Col>
                    <Badge
                      variant={
                        event.status == "pending" ? "warning" : "success"
                      }
                      className="event-status"
                    >
                      {event.status}
                    </Badge>
                  </Col>
                  <Col className="text-right">
                    {event.txHash === null ? (
                      "-"
                    ) : (
                      <OverlayTrigger
                        overlay={
                          <Tooltip id={`tooltip-fee`}>Transaction fee</Tooltip>
                        }
                      >
                        <span className="tx-fee has-tooltip">
                          {event.fee + " CKB"}{" "}
                        </span>
                      </OverlayTrigger>
                    )}
                  </Col>
                </Row>
              </Container>
            </Card.Body>
          </Card>
        );
      })}
    </React.Fragment>
  );
};

export default ClaimEventList;
