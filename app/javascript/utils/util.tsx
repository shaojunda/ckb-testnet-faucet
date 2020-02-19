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
export const formatAddressHash = (addressHash: string) => {
  if (addressHash === null || addressHash === undefined) {
    return "";
  }
  let addressHashMaxLength;
  const screenWidth = window !== undefined ? window.innerWidth : 500;
  if (screenWidth <= 480) {
    addressHashMaxLength = 13;
  } else if (screenWidth > 480 && screenWidth <= 768) {
    addressHashMaxLength = 29;
  } else {
    addressHashMaxLength = 46;
  }
  const addressHashLength = addressHash.length;
  if (addressHashLength > addressHashMaxLength) {
    const difference = addressHashLength - addressHashMaxLength;
    const middlePosition = parseInt(String(addressHashLength / 2));
    const quotient = parseInt(String((difference - 1) / 2));
    const remainder = (difference - 1) % 2;
    const part1 = addressHash.substring(0, middlePosition - quotient - 2);
    const part2 = addressHash.substring(
      middlePosition + quotient + remainder + 2
    );
    return part1 + "..." + part2;
  } else {
    return addressHash;
  }
};

export const context = React.createContext("");
