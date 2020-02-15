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
