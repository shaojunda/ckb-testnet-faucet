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
          placeholder="Enter your Aggron wallet address"
          aria-label="Aggron address"
          aria-describedby="Enter your Aggron wallet address"
          name="address_hash"
          value={address_hash}
          onChange={handleInput}
        />
        <InputGroup.Append>
          <Button variant="outline-light" type="submit">
            Claim
          </Button>
        </InputGroup.Append>
      </InputGroup>
    </Form>
  );
};

export default ClaimEventForm;
