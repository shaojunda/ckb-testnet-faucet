import React from "react";
import { Navbar } from "react-bootstrap";

const Footer: React.FC = () => {
  const getCurrentYear = () => {
    return new Date().getFullYear();
  };
  return (
    <Navbar fixed="bottom" className="footer">
      <p>{`Copyright © ${getCurrentYear()} Nervos Foundation. All Rights Reserved.`}</p>
    </Navbar>
  );
};
export default Footer;
