import React from "react";
import { Button, InputGroup, FormControl, Form } from "react-bootstrap";

interface ClaimEventFormProps {
  address_hash: string;
  handleInput: React.ChangeEventHandler<HTMLInputElement>;
  handleSubmit: React.FormEventHandler<HTMLFormElement>;
}

const ClaimEventForm: React.FC<ClaimEventFormProps> = ({
  address_hash,
  handleInput,
  handleSubmit
}) => {
  return (
    <Form onSubmit={handleSubmit}>
      <InputGroup className="mb-3">
        <FormControl
          placeholder="Please enter Aggron address e.g. ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
          aria-label="Aggron address"
          aria-describedby="Aggron address e.g. ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
          name="address_hash"
          value={address_hash}
          onChange={handleInput}
        />
        <InputGroup.Append>
          <Button variant="outline-secondary" type="submit">
            Claim
          </Button>
        </InputGroup.Append>
      </InputGroup>
    </Form>
  );
};

export default ClaimEventForm;
