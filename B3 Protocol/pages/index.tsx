import Link from "next/link";
import type { NextPage } from "next";
import { AtSymbolIcon, MagnifyingGlassIcon, SparklesIcon } from "@heroicons/react/24/outline";
import { MetaHeader } from "~~/components/MetaHeader";

const Home: NextPage = () => {
  return (
    <>
      <MetaHeader />
      <div className="flex items-center flex-col flex-grow pt-10 ">
        <div className="px-5">
          <h1 className="text-center mb-8">
            <span className="block text-2xl mb-2">plant on the Blockchain with</span>
            <span className="block text-4xl font-bold">BR33D3R</span>
          </h1>
          <p className="text-center text-lg">
            Buy, Sell, Swap real plants, seeds, pollen...and know your seeds are from reputable sources
          </p>
          <p className="text-center text-lg">
            get started by taking a short survey and logging your answers on chain
            <p>using the Ethereum Attestation Service and Chainlinks CCIP (Cross Chain Interoperability Protocol)</p>
          </p>
        </div>

        <div className="flex-grow bg-base-300 w-full mt-16 px-8 py-12">
          <div className="flex justify-center items-center gap-12 flex-col sm:flex-row">
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <SparklesIcon className="h-8 w-8 fill-secondary" />
              <p>
                S0W Y0UR F1RST S33D ON OPTIMISM W1TH{" "}
                <Link href="/S01L" passHref className="link">
                  'S01L'
                </Link>{" "}
              </p>
            </div>
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <AtSymbolIcon className="h-8 w-8 fill-secondary" />
              <p>
                Plant your S33D's in S01L and use them to{" "}
                <Link href="/theFarm" passHref className="link">
                  Index Plants IRL
                </Link>{" "}
              </p>
            </div>

            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <MagnifyingGlassIcon className="h-8 w-8 fill-secondary" />
              <p>
                Explore Seed Contracts in our{" "}
                <Link href="/S33DB4NK" passHref className="link">
                  S33DB4NK
                </Link>{" "}
                tab.
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
