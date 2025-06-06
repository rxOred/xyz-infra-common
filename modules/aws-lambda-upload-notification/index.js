const AWS = require("aws-sdk");
const SES = new AWS.SES();

const FROM_EMAIL = process.env.FROM_EMAIL;
const TO_EMAIL = process.env.TO_EMAIL;

exports.handler = async (event) => {
  try {
    for (const record of event.Records) {
      const body = JSON.parse(record.body);

      const emailParams = {
        Source: FROM_EMAIL,
        Destination: {
          ToAddresses: [TO_EMAIL],
        },
        Message: {
          Subject: {
            Data: `📦 New Upload: ${body.filename}`,
          },
          Body: {
            Text: {
              Data:
                `A new file was uploaded:\n\n` +
                `File: ${body.filename}\n` +
                `User ID: ${body.uploaded_by}\n` +
                `Upload ID: ${body.upload_id}\n` +
                `Status: ${body.status}\n` +
                `Time: ${body.timestamp}`,
            },
          },
        },
      };

      await SES.sendEmail(emailParams).promise();
    }

    return { statusCode: 200, body: "Emails sent" };
  } catch (error) {
    console.error("Notification handler error:", error);
    return { statusCode: 500, body: "Failed to send notification" };
  }
};
