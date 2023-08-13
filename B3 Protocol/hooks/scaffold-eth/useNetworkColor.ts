import { useDarkMode } from "usehooks-ts";
import { getTargetNetwork } from "~~/utils/scaffold-eth";

const DEFAULT_NETWORK_COLOR: [string, string] = ["#6EFBC4", "#64E36D"];

export const useNetworkColor = () => {
  const { isDarkMode } = useDarkMode();
  const colorConfig = getTargetNetwork().color ?? DEFAULT_NETWORK_COLOR;

  return Array.isArray(colorConfig) ? (isDarkMode ? colorConfig[1] : colorConfig[0]) : colorConfig;
};
