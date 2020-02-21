import React from "react";
import { Navbar, Container, Row, Col } from "react-bootstrap";
import FooterLogo from "../images/ckb_footer_logo.png";
import FooterAbout from "../images/footer_about.png";
import FooterDocs from "../images/footer_docs.png";
import FooterGitHub from "../images/footer_github.png";
import FooterWhitePaper from "../images/footer_whitepaper.png";
import FooterTwitter from "../images/footer_twitter.png";
import FooterBlog from "../images/footer_blog.png";
import FooterTelegram from "../images/footer_telegram.png";
import FooterReddit from "../images/footer_reddit.png";
import FooterYouTube from "../images/footer_youtube.png";
import FooterForum from "../images/footer_forum.png";

const Footer: React.FC = () => {
  const getCurrentYear = () => {
    return new Date().getFullYear();
  };
  return (
    <React.Fragment>
      <Container fluid className="footer-container">
        <Row className="justify-content-center align-items-center">
          <Col xs="12" sm="12" md="12" lg="5" xl="5">
            <Container className="d-flex align-items-center justify-content-center">
              <Row>
                <Col>
                  <img
                    src={FooterLogo}
                    className="footer-logo"
                    alt="footer logo"
                  />
                </Col>
              </Row>
            </Container>
          </Col>
          <Col>
            <Container className="footer-items-container">
              <Row className="justify-content-start align-items-end">
                <Col className="d-flex align-items-end footer-item-col">
                  <span className="footer-title">Foundation</span>
                  <div className="footer-items">
                    <a
                      href="https://www.nervos.org/"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterAbout} alt="about us icon" />
                      </div>
                      <div className="footer-icon-description">About Us</div>
                    </a>
                  </div>
                </Col>
              </Row>
              <Row className="justify-content-start align-items-end">
                <Col className="d-flex align-items-end footer-item-col">
                  <span className="footer-title">Developer</span>
                  <div className="footer-items">
                    <a
                      href="https://docs.nervos.org"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterDocs} alt="docs icon" />
                      </div>
                      <div className="footer-icon-description">Docs</div>
                    </a>

                    <a
                      href="https://github.com/nervosnetwork"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterGitHub} alt="github icon" />
                      </div>
                      <div className="footer-icon-description">GitHub</div>
                    </a>

                    <a
                      href="https://github.com/nervosnetwork/rfcs/blob/master/rfcs/0002-ckb/0002-ckb.md"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterWhitePaper} alt="whitepaper icon" />
                      </div>
                      <div className="footer-icon-description">WhitePaper</div>
                    </a>

                    <a
                      href="https://explorer.nervos.org/aggron/"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <i className="fab fa-searchengin"></i>
                      </div>
                      <div className="footer-icon-description">Explorer</div>
                    </a>
                  </div>
                </Col>
              </Row>
              <Row className="justify-content-start align-items-end">
                <Col className="d-flex align-items-end footer-item-col">
                  <span className="footer-title">Community</span>
                  <div className="footer-items">
                    <a
                      href="https://twitter.com/nervosnetwork"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterTwitter} alt="github icon" />
                      </div>
                      <div className="footer-icon-description">Twitter</div>
                    </a>
                    <a
                      href="https://medium.com/nervosnetwork"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterBlog} alt="blog icon" />
                      </div>
                      <div className="footer-icon-description">Blog</div>
                    </a>
                    <a
                      href="https://t.me/nervosnetwork"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterTelegram} alt="telegram icon" />
                      </div>
                      <div className="footer-icon-description">Telegram</div>
                    </a>
                    <a
                      href="https://www.reddit.com/r/NervosNetwork/"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterReddit} alt="reddit icon" />
                      </div>
                      <div className="footer-icon-description">Reddit</div>
                    </a>
                    <a
                      href="https://www.youtube.com/channel/UCONuJGdMzUY0Y6jrPBOzH7A"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterYouTube} alt="youtube icon" />
                      </div>
                      <div className="footer-icon-description">YouTube</div>
                    </a>
                    <a
                      href="https://talk.nervos.org/"
                      target="_blank"
                      className="footer-item-container d-flex justify-content-center align-items-center"
                    >
                      <div className="footer-icon-container">
                        <img src={FooterForum} alt="forum icon" />
                      </div>
                      <div className="footer-icon-description">Forum</div>
                    </a>
                  </div>
                </Col>
              </Row>
            </Container>
          </Col>
        </Row>
      </Container>
      <Navbar sticky="bottom" className="footer">
        <p>{`Copyright © ${getCurrentYear()} Nervos Foundation. All Rights Reserved.`}</p>
      </Navbar>
    </React.Fragment>
  );
};
export default Footer;
