require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // Agrega esta línea para cargar las variables de entorno

module.exports = {
  solidity: "0.8.26",
  networks: {
    sepolia: {
      url: process.env.INFURA_API_KEY ? `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}` : "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    }
  }
};