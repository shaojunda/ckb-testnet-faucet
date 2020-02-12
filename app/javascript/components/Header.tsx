import React from "react";
import { Navbar } from "react-bootstrap";

const Header: React.FC = () => {
  return (
    <Navbar className="nav-bg">
      <Navbar.Brand href="/">
        <div className="nav-logo"></div>
      </Navbar.Brand>
    </Navbar>
  );
};

export default Header;
