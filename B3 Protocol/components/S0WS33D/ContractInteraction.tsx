import { useState } from "react";
import { ArrowSmallRightIcon } from "@heroicons/react/24/outline";
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export const ContractInteraction = () => {
  const [visible] = useState(true);
  const [step, setStep] = useState<number>(0);
  const [formData, setFormData] = useState<{
    plantName: string;
    plantSymbol: string;
  }>({
    plantName: "",
    plantSymbol: "",
  });

  const { writeAsync, isLoading } = useScaffoldContractWrite({
    contractName: "S01L",
    functionName: "S0WS33D",
    args: [formData.plantName, formData.plantSymbol], // Updated to pull data from formData
    value: "0.00",
    onBlockConfirmation: txnReceipt => {
      console.log("📦 Transaction blockHash", txnReceipt.blockHash);
    },
  });

  const handleChange = e => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };


  const handleSubmit = async e => {
    e.preventDefault();
    if (step < 3) {
      setStep(prev => prev + 1);
    } else {
      await writeAsync();
      // Reset formData after the transaction is complete
      setFormData({
        plantName: "",
        plantSymbol: "",
      });
      setStep(0); // Optionally, you can reset to the initial step after submission.
    }
  };
  const renderStepContent = () => {
    switch (step) {
      case 0:
        return (
          <input
            type="text"
            placeholder="what do you want to name your plant... have fun with it.?"
            name="plantName"
            value={formData.plantName}
            onChange={handleChange}
            className="input font-bai-jamjuree w-full px-5"
          />
        );
      case 1:
        return (
          <input
            type="text"
            placeholder="What's your plants flavor or variety... whats its common name?"
            name="plantSymbol"
            value={formData.plantSymbol}
            onChange={handleChange}
            className="input font-bai-jamjuree w-full px-5"
          />
        );
      default:
        return null;
    }
  };

  return (
    <div className="flex bg-[url('/background.jpg')] bg-[length:100%_100%]  relative pb-10" onSubmit={handleSubmit}>
      <div className="flex flex-col w-full mx-5 sm:mx-8 2xl:mx-20">
        <div className={`mt-10 flex gap-2 ${visible ? "" : "invisible"} max-w-2xl`}>
        </div>

        <div className="flex flex-col mt-6 px-7 py-8 bg-base-600 opacity-100 rounded-2xl shadow-lg border-2 border-primary">
          <span className="text-4xl sm:items-right sm:text-6xl text-white">
            {step < 2 ? "tell us about your plant" : "Upload"}
          </span>
          <div className="mt-8 flex flex-col sm:flex-row items-start sm:items-center gap-2 sm:gap-5">
            {renderStepContent()}
            <div className="flex rounded-full border border-primary p-1 flex-shrink-0">
              <div className="flex rounded-full border-2 border-primary p-1">
                {" "}
                <button
                  className={`btn btn-primary rounded-full capitalize font-normal font-white w-24 flex items-center gap-1 hover:gap-2 transition-all tracking-widest ${
                    isLoading ? "loading" : ""
                  }`}
                  onClick={handleSubmit}
                >
                  {!isLoading && (
                    <>
                      {step < 2 ? "Next" : "Submit"} <ArrowSmallRightIcon className="w-3 h-3 mt-0.5" />
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
