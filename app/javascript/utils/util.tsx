import React from "react";

export const parseSimpleDate = (timestamp: number | string) => {
  const date = new Date(Number(timestamp) * 1000);
  return `${date.getFullYear()}/${date.getMonth() +
    1}/${date.getDate()} ${formatData(date.getHours())}:${formatData(
    date.getMinutes()
  )}:${formatData(date.getSeconds())}`;
};
export const formatData = (data: number) => {
  return data < 10 ? `0${data}` : data;
};
export const formatHash = (hash: string, hashType: string) => {
  if (hash === null || hash === undefined) {
    return "";
  }
  const windowWidth = typeof window !== "undefined" ? window.innerWidth : 500;
  let hashMaxLength = getHashMaxLength(windowWidth, hashType);
  const hashLength = hash.length;
  if (hashLength > hashMaxLength) {
    const difference = hashLength - hashMaxLength;
    const middlePosition = parseInt(String(hashLength / 2));
    const quotient = parseInt(String((difference - 1) / 2));
    const remainder = (difference - 1) % 2;
    const part1 = hash.substring(0, middlePosition - quotient - 2);
    const part2 = hash.substring(middlePosition + quotient + remainder + 2);
    return part1 + "..." + part2;
  } else {
    return hash;
  }
};
export const getHashMaxLength = (windowWidth: number, hashType: string) => {
  switch (hashType) {
    case "tx":
      if (windowWidth <= 320) {
        return 14;
      } else if (windowWidth > 320 && windowWidth <= 480) {
        return 20;
      } else if (windowWidth > 480 && windowWidth <= 768) {
        return 29;
      } else if (windowWidth > 768 && windowWidth <= 1024) {
        return 50;
      } else {
        return 66;
      }
    case "address":
      if (windowWidth <= 320) {
        return 14;
      } else if (windowWidth > 320 && windowWidth <= 480) {
        return 20;
      } else if (windowWidth > 480 && windowWidth <= 768) {
        return 29;
      } else {
        return 46;
      }
    default:
      return 46;
  }
};

export const context = React.createContext("");
