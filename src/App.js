import React, { useState } from 'react';
import { ethers } from 'ethers';
import './App.css';

// Adresa Lido ugovora (na Ethereum mainnetu)
const LIDO_ADDRESS = process.env.REACT_APP_LIDO_ADDRESS;

// Minimalni ABI za Lido
const ABI = [
  "function submit(address referral) external payable returns (uint256)",
  "function balanceOf(address account) external view returns (uint256)"
];

function App() {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [stakeAmount, setStakeAmount] = useState("");
  const [stEthBalance, setStEthBalance] = useState("");

  const connectWallet = async () => {
    try {
      const prov = new ethers.providers.Web3Provider(window.ethereum);
      await prov.send("eth_requestAccounts", []);
      const signer = prov.getSigner();
      setProvider(prov);
      setSigner(signer);
    } catch (error) {
      alert("Greška pri povezivanju wallet-a");
    }
  };

  const stakeEth = async () => {
    try {
      const lido = new ethers.Contract(LIDO_ADDRESS, ABI, signer);
      const tx = await lido.submit(ethers.constants.AddressZero, {
        value: ethers.utils.parseEther(stakeAmount)
      });
      await tx.wait();
      alert("Uspešno stake-ovano!");
    } catch (error) {
      alert("Greška prilikom stake-ovanja");
      console.error(error);
    }
  };

  const getBalance = async () => {
    try {
      const lido = new ethers.Contract(LIDO_ADDRESS, ABI, provider);
      const address = await signer.getAddress();
      const balance = await lido.balanceOf(address);
      setStEthBalance(ethers.utils.formatEther(balance));
    } catch (error) {
      alert("Greška pri čitanju balansa");
    }
  };

  return (
  <div className="App">
    <h1>Lido Staking</h1>
    <button onClick={connectWallet}>Poveži Wallet</button>

    <div>
      <input
        type="text"
        placeholder="Količina ETH"
        value={stakeAmount}
        onChange={(e) => setStakeAmount(e.target.value)}
      />
      <button onClick={stakeEth}>Stake ETH</button>
    </div>

    <div>
      <button onClick={getBalance}>Prikaži stETH balans</button>
      <p>Balans: {stEthBalance} stETH</p>
    </div>

    <div>
      <button onClick={() => alert(`
Unstake nije direktno podržan.
Da biste dobili ETH nazad, zamenite stETH za ETH na DEX-u (npr. Curve ili 1inch).
  `)}>
        Unstake (simulacija)
      </button>
    </div>
  </div>
);

}

export default App;
