import React, { useContext } from "react";
import {
  Card,
  Container,
  Row,
  Col,
  Badge,
  Tooltip,
  OverlayTrigger
} from "react-bootstrap";
import { parseSimpleDate, formatAddressHash, context } from "../utils/util";

const ClaimEvent: React.FC<ClaimEventProps> = ({ claimEvent }) => {
  const aggronExplorerHost = useContext(context);
  const explorer_address_url = aggronExplorerHost + "/address/";
  const explorer_transaction_url = aggronExplorerHost + "/transaction/";
  return (
    <Card>
      <Card.Header>
        <Container>
          <Row>
            <Col>
              <span className="hash-letter">
                {claimEvent.txHash === null ? (
                  <OverlayTrigger
                    overlay={
                      <Tooltip id={`tooltip-txHash`}>
                        The transaction has entered the queue, please be patient
                      </Tooltip>
                    }
                  >
                    <span className="has-tooltip">-</span>
                  </OverlayTrigger>
                ) : (
                  <a
                    href={explorer_transaction_url + claimEvent.txHash}
                    target="_blank"
                  >
                    {claimEvent.txHash}
                  </a>
                )}
              </span>
            </Col>
            <Col className="text-right">
              <span className="pull-right timestamp">
                {parseSimpleDate(claimEvent.timestamp)}
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
                  href={explorer_address_url + claimEvent.addressHash}
                  target="_blank"
                >
                  {formatAddressHash(claimEvent.addressHash)}
                </a>
              </span>
            </Col>
            <Col className="text-right">
              <OverlayTrigger
                overlay={
                  <Tooltip id={`tooltip-capacity`}>Claimed capacity</Tooltip>
                }
              >
                <span className="has-tooltip">{claimEvent.capacity} CKB</span>
              </OverlayTrigger>
            </Col>
          </Row>
          <Row>
            <Col>
              <Badge
                variant={claimEvent.status == "pending" ? "warning" : "success"}
                className="event-status"
              >
                {claimEvent.status}
              </Badge>
            </Col>
            <Col className="text-right">
              {claimEvent.txHash === null ? (
                "-"
              ) : (
                <OverlayTrigger
                  overlay={
                    <Tooltip id={`tooltip-fee`}>Transaction fee</Tooltip>
                  }
                >
                  <span className="tx-fee has-tooltip">
                    {claimEvent.fee + " CKB"}{" "}
                  </span>
                </OverlayTrigger>
              )}
            </Col>
          </Row>
        </Container>
      </Card.Body>
    </Card>
  );
};

export default ClaimEvent;
