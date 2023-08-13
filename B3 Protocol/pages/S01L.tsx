import { ApolloClient, ApolloProvider, InMemoryCache } from "@apollo/client";
import { ThemeProvider, createTheme } from "@mui/material";
import type { NextPage } from "next";
import { MetaHeader } from "~~/components/MetaHeader";
import { ContractInteraction } from "~~/components/S0WS33D/ContractInteraction";
import { S01LInfoCard } from "~~/components/S0WS33D/S01LInfoCard";

const theme = createTheme();

const client = new ApolloClient({
  uri: "https://api.thegraph.com/subgraphs/name/foamlabs/br33d3r-protocol-s01l",
  cache: new InMemoryCache(),
});

const ExampleUI: NextPage = () => {
  return (
    <>
      <MetaHeader
        title="Create S33D Contracts on the Optimism SuperChain"
        description="Take a small survey and upload a picture of your seeds to the blockchain to start your breeding programs today. "
      >
        {/* We are importing the font this way to lighten the size of SE2. */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link href="https://fonts.googleapis.com/css2?family=Bai+Jamjuree&display=swap" rel="stylesheet" />
      </MetaHeader>
      <div className="grid lg:grid-row-3 flex-grow" data-theme="scaffoldEthDark">
        <ContractInteraction />
        <ThemeProvider theme={theme}>
          <ApolloProvider client={client}>
            <S01LInfoCard />
          </ApolloProvider>
        </ThemeProvider>
      </div>
    </>
  );
};

export default ExampleUI;
