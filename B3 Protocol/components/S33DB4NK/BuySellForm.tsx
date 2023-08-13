import React from "react";

const BuySellForm: React.FC = () => {
  return (
    <div style={{ border: "1px solid black", padding: "16px", minWidth: "275px" }}>
      <h2>Buy / Sell</h2>
      <input type="text" placeholder="Amount" />
      <input type="text" placeholder="Price" />
      <button style={{ backgroundColor: "blue", color: "white", padding: "8px 16px", margin: "8px" }}>BuyOrSell</button>
    </div>
  );
};

export default BuySellForm;
