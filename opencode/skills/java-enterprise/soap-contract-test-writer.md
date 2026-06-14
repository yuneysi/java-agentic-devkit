# SOAP Contract Test Writer Skill

Use this skill when the user asks to create or improve tests for SOAP/XML behavior during a Java 8 to Java 21 migration.

## Goal

Create characterization tests that capture the existing Java 8 SOAP/XML behavior and protect it during Java 21 migration.

Java 8 is the behavioral source of truth.

## Rules

- Do not rewrite SOAP contracts unless explicitly requested.
- Do not silently normalize XML differences.
- Do not change production SOAP code unless a failing characterization test proves a regression.
- Preserve WSDL, XSD, namespaces, SOAPAction, JAXB annotations, XML prefixes, element names, element order, date formatting, and BigDecimal formatting.
- Report XML namespace differences explicitly.
- Report null vs empty tag differences explicitly.
- Report encoding differences explicitly.
- Avoid over-normalizing XML in tests.
- Prefer deterministic snapshots and stable fixtures.

## Inspect For

- `javax.xml.bind.*`
- `javax.xml.ws.*`
- `javax.xml.soap.*`
- `javax.jws.*`
- `javax.xml.namespace.*`
- JAXB generated classes.
- WSDL files.
- XSD files.
- SOAP endpoint classes.
- SOAP client classes.
- SOAP fault handling.
- XML marshalling and unmarshalling code.

## Useful Search Commands

```bash
rg "javax\.xml|javax\.jws|javax\.soap|javax\.xml\.ws|javax\.xml\.bind"
rg "JAXB|Marshaller|Unmarshaller|XmlElement|XmlRootElement|XmlType|QName|Namespace|SOAPAction"
rg "wsdl|xsd|soap|SOAP|WebService|WebMethod|WebParam|WebResult"
```

## Recommended Test Types

Create tests for:

- SOAP request generation.
- SOAP response generation.
- SOAP fault generation.
- JAXB marshalling.
- JAXB unmarshalling.
- WSDL/XSD compatibility where possible.
- Namespace preservation.
- SOAPAction behavior.
- Date/time formatting.
- BigDecimal formatting.
- Null vs empty tag behavior.

## Snapshot Location

Prefer storing snapshots under:

```text
src/test/resources/snapshots/soap/
```

Example files:

```text
src/test/resources/snapshots/soap/customer-request-java8.xml
src/test/resources/snapshots/soap/customer-response-java8.xml
src/test/resources/snapshots/soap/error-response-java8.xml
```

## Example Test Intent

The test should prove:

```text
Given a known Java 8 input,
when the SOAP payload is generated,
then the XML output matches the Java 8 baseline snapshot.
```

## Required Output

When writing tests, provide:

- Files added or changed.
- What SOAP behavior is protected.
- What snapshot data was introduced.
- What XML differences the test will detect.
- Commands to run the tests.
- Any assumptions or missing fixtures.

## Do Not Do

- Do not replace SOAP with REST.
- Do not migrate `javax.*` to `jakarta.*` unless explicitly asked.
- Do not remove namespaces.
- Do not ignore namespace differences.
- Do not hide date/time or BigDecimal formatting differences.
