import React from "react";

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
    <React.Fragment>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          name="address_hash"
          value={address_hash}
          onChange={handleInput}
          placeholder="Please input Aggron short format address e.g. ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
        />
        <button type="submit">Claim</button>
      </form>
    </React.Fragment>
  );
};

export default ClaimEventForm;
