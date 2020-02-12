import React from "react";
import { Navbar } from "react-bootstrap";
import Logo from "../images/ckb_logo.png";

const Header: React.FC = () => {
  return (
    <Navbar className="nav-bg">
      <Navbar.Brand href="/">
        <img alt="ckb logo" src={Logo} className="logo" /> React Bootstrap
      </Navbar.Brand>
    </Navbar>
  );
};

export default Header;
