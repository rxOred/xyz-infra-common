const AWS = require("aws-sdk");
const S3 = new AWS.S3();
const DynamoDB = new AWS.DynamoDB.DocumentClient();
const SQS = new AWS.SQS();

const TABLE_NAME = process.env.TABLE_NAME;
const QUEUE_URL = process.env.QUEUE_URL;

exports.handler = async (event) => {
  try {
    for (const record of event.Records) {
      const bucket = record.s3.bucket.name;
      const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, " "));

      // Extract userId from path: uploads/{userId}/filename.csv
      const [, userId] = key.split("/");

      const uploadId = `${Date.now()}-${Math.floor(Math.random() * 1000)}`;

      const item = {
        upload_id: uploadId,
        uploaded_by: userId,
        filename: key.split("/").pop(),
        s3_path: `s3://${bucket}/${key}`,
        timestamp: new Date().toISOString(),
        status: "PENDING",
      };

      // Save to DynamoDB
      await DynamoDB.put({
        TableName: TABLE_NAME,
        Item: item,
      }).promise();

      // Send to SQS
      await SQS.sendMessage({
        QueueUrl: QUEUE_URL,
        MessageBody: JSON.stringify(item),
      }).promise();
    }

    return { statusCode: 200, body: "File processed and queued" };
  } catch (error) {
    console.error("Upload handler error:", error);
    return { statusCode: 500, body: "Error processing file" };
  }
};
