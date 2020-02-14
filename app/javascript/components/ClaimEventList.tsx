import React from "react";
import { Card, Container, Row, Col, Badge } from "react-bootstrap";

const ClaimEventList: React.FC<ClaimEventListProps> = ({ claimEvents }) => {
  return (
    <React.Fragment>
      {claimEvents.map(event => {
        return (
          <Card key={event.id} className="pull-right">
            <Card.Header>
              <Container>
                <Row>
                  <Col>
                    <span className="hash-letter">
                      {event.txStatus == "pending" ? "-" : event.txHash}
                    </span>
                  </Col>
                  <Col className="text-right">
                    <span className="pull-right">{event.timestamp}</span>
                  </Col>
                </Row>
              </Container>
            </Card.Header>
            <Card.Body>
              <Container>
                <Row>
                  <Col>
                    <span className="hash-letter">{event.addressHash}</span>
                  </Col>
                  <Col className="text-right">
                    <span>{event.capacity} CKB</span>
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
                    <span>{event.fee} CKB</span>
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
