# JMS Characterization Test Writer Skill

Use this skill when the user asks to create or improve JMS tests for a Java 8 to Java 21 migration or ActiveMQ to IBM MQ migration.

## Goal

Create characterization tests that capture current Java 8 JMS behavior and protect it during Java 21 migration.

Java 8 is the behavioral source of truth.

## Rules

- Do not change destination names without explicit approval.
- Do not change acknowledgement mode without tests and explanation.
- Do not change retry, redelivery, transaction, or dead-letter behavior without tests and explanation.
- Do not change message payload structure without tests.
- Do not modify production code unless a failing characterization test proves a behavioral regression.
- Compare ActiveMQ and IBM MQ differences explicitly.
- Preserve current behavior unless a change is explicitly requested.

## Inspect For

- `javax.jms.*`
- `JmsTemplate`
- `MessageListener`
- `DefaultMessageListenerContainer`
- `ActiveMQConnectionFactory`
- IBM MQ connection factories.
- Queue and topic definitions.
- Message converters.
- Correlation IDs.
- ReplyTo behavior.
- Error handlers.
- Transaction managers.
- Redelivery configuration.
- Dead-letter queue configuration.

## Useful Search Commands

```bash
rg "javax\.jms|JmsTemplate|MessageListener|DefaultMessageListenerContainer|ActiveMQ|IBM|MQQueue|MQConnection|MQDestination"
rg "correlation|replyTo|acknowledge|redelivery|dead.letter|DLQ|transaction|ConnectionFactory"
rg "Queue|Topic|MessageConverter|TextMessage|BytesMessage|ObjectMessage|MapMessage"
```

## Test Areas

Create tests for:

- Destination names.
- Queue vs topic behavior.
- Message payload.
- Headers.
- Properties.
- Correlation ID.
- ReplyTo.
- Delivery mode.
- Priority.
- Time to live.
- Acknowledgement mode.
- Transaction behavior.
- Redelivery behavior.
- Error handling.
- Dead-letter behavior.
- Message conversion.

## Recommended Strategy

If a local broker is available, create integration tests with ActiveMQ.

If IBM MQ is not available locally, create tests for message creation and configuration behavior first.

At minimum, protect the message payload, headers, destination names, and correlation behavior.

## Required Output

When writing tests, provide:

- Files added or changed.
- JMS behavior covered.
- Destinations covered.
- Headers/properties covered.
- Broker assumptions.
- Commands to run the tests.
- Remaining JMS risks.
