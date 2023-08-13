import React, { FC, useState } from "react";
import { BuySellForm, ExchangePoolForm, Listings, SwapForm } from "../components/S33DB4NK/index";
import { Card, CardContent, Tab, Tabs } from "@mui/material";

const S33DB4NK: FC = () => {
  const [selectedTab, setSelectedTab] = useState(0); // 0 for SwapForm, 1 for BuySellForm, and so on

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  return (
    <Card>
      <div style={{ display: "flex", backgroundColor:"#5a5654", flexDirection: "column", alignItems: "center" }}>
        <Card
          sx={{
            maxWidth: "90%",
            margin: "2rem auto",
            padding: "1rem",
          }}
        >
          <CardContent>
            <h2>THE BR33D3R2 PROTOCOL & the S33DB4NK</h2>
            <p>The S33DB4NK is a semi-Decentralized seedbank or seed index that allows users to buys sell and trade S33D tokens while keeping an immutable ledger of plant genetics on the blockchain. This protocol will start as a primitive platform and with the proper root files and IRL root systems these S33D's will grow into a robust community of gardeners, biologists, traders, and technologists. Join us and swap some seeds on optimism today. </p>
          </CardContent>
        </Card>

        {/* Your main card code goes here... */}
      </div>
      <div style={{backgroundcolor:"#5a5654"}}>
      <Card 
        sx={{
          maxWidth: "90%",
          margin: "4rem auto",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
        }}
      >
        <CardContent>
          <h1 className="s33db4nk-title">S33DB4NK</h1>
          <Tabs value={selectedTab} onChange={handleTabChange} centered>
            <Tab label="Swap" />
            <Tab label="Buy/Sell" />
            <Tab label="Exchange Pool" />
          </Tabs>
          {selectedTab === 0 && <SwapForm />}
          {selectedTab === 1 && <BuySellForm />}
          {selectedTab === 2 && <ExchangePoolForm />}
          <Listings />
        </CardContent>
      </Card>
      </div>
    </Card>
  );
};

export default S33DB4NK;
