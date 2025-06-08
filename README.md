
# Blind Pulse: An Auction Smart Contract

A configurable **Ethereum auction smart contract** written in Solidity, featuring dynamic commission fees, customizable fee recipient address, and automatic bid time extension to ensure fair bidding.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Contract Details](#contract-details)
- [Installation](#installation)
- [Usage](#usage)
- [Deployment](#deployment)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This smart contract implements a transparent auction system on the Ethereum blockchain. Bidders compete by submitting increasing bids, with the auction automatically extending if bids come in near the end time to prevent last-second sniping. The owner can configure the commission fee percentage and the recipient address for that fee.

---

## Features

- Place bids that must be at least 5% higher than the current highest.
- Automatic refund of previous bids to bidders when they are outbid.
- Auction time extends by 10 minutes if a bid arrives near the auction end.
- Owner can finalize the auction and receive funds minus a configurable commission.
- Commission percentage and commission recipient address are updateable by the owner.
- Losers can withdraw their funds after auction ends.
- Events emitted for major actions: new bid, auction ended, fee updates.

---

## Contract Details

- **Language:** Solidity 0.8.26
- **License:** GPL-3.0
- **Main contract:** `Auction`
- **Key structs:**
  - `Bid`: Tracks bidder address and bid amount.
- **Key variables:**
  - `owner`: Auction owner.
  - `feeReceiver`: Address receiving the commission.
  - `feePercent`: Commission percentage (0-100).
  - `endTime`: Timestamp auction ends.
  - `highestBid` / `highestBidder`: Current best bid and bidder.
  - `auctionEnded`: Boolean flag marking auction completion.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/auction-contract.git
   cd auction-contract
   ```

2. Install dependencies (requires Node.js and npm):
   ```bash
   npm install
   ```

---

## Usage

- **Place a bid:**
  Send an Ethereum transaction calling `bid()` with `msg.value` at least 5% greater than current highest bid.

- **End the auction:**
  Only the owner can call `endAuction()` after the auction end time to finalize and distribute funds.

- **Refund losers:**
  Losing bidders call `refundLosers()` to retrieve their deposited amounts.

- **Update fee settings:**
  Owner calls `updateFeePercent(uint)` or `updateFeeReceiver(address)` to adjust commission parameters.

---

## Deployment

Use Hardhat or your preferred deployment tool.

Example deployment script snippet:

```js
const Auction = await ethers.getContractFactory("Auction");
const auction = await Auction.deploy(durationInMinutes, feeReceiverAddress, feePercent);
await auction.deployed();
console.log("Auction deployed at:", auction.address);
```

---

## Configuration

- **feePercent:** Commission as a percentage (0-100).
- **feeReceiver:** Address receiving commission payments.
- Both are configurable by the owner post-deployment.

---

## Running Tests

Tests can be added in the `test` directory and run with:

```bash
npx hardhat test
```

(Tests not included in this repository by default.)

---

## Security Considerations

- Only the owner can finalize the auction or change fee settings.
- Bidders receive refunds if outbid.
- The contract assumes the `feeReceiver` is a trusted address.
- Avoid sending bids below the minimum required to prevent revert.
- Audit recommended before production use.

---

## Contributing

Contributions and suggestions are welcome! Please open issues or pull requests.

---

## License

This project is licensed under the GPL-3.0 License.

---

*Developed by Nicolás O.
