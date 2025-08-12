# Core: A Foundation Data Model for Federal Power Platform Apps

When building government applications on the Power Platform, one of the biggest challenges is that so many projects start from scratch, even when they share the same underlying data needs. Whether you’re working on case management, grants, compliance, HR, or procurement, there is a recurring set of tables, fields, and relationships that almost every app will need. The Government Data Models – Core module is designed to solve this problem by providing a shared, reusable backbone of common entities that federal agencies can build on, saving time while improving consistency across solutions.

At its heart, the module is a curated set of Dataverse tables that cover the core concepts most government processes depend on. It brings together people and organizational data, legal and compliance references, documents and approvals, geographic and jurisdictional boundaries, program and workforce classifications, as well as risk and impact assessment structures. These are not just arbitrary tables—they have been shaped with government data patterns in mind, including the need for historical tracking, reference code alignment with federal standards, and secure handling of sensitive information.

For example, the module’s Person table isn’t simply a contact list; it’s designed to handle multiple organizational assignments over time, link individuals to their competencies, track clearance levels with effective dating, and store personal information securely under field-level security rules. The Account and Organization Unit tables can represent agencies, vendors, or grantees and the internal divisions, programs, or offices within them. On the legal side, tables such as Legal Authority, Compliance Framework, and Compliance Requirement allow agencies to tie regulations directly to the controls and evidence that demonstrate compliance, creating a living connection between statutory obligations and day-to-day operations.

Content management is also a core feature. The Document table supports versioning, storage references, and relationships to agreements, compliance requirements, or risk assessments. Signature Approval and Review Approval Decision create consistent patterns for capturing approvals and decisions across any process, whether it’s signing off on a grant award or reviewing a policy document. Geographic reference tables like Country, State or Province, Judicial District, and Location ensure that apps use standardized place data, improving reporting and interoperability.

The benefit of this approach becomes clear when you consider real-world applications. A FOIA or privacy request app could use the Person table to track requesters, the Legal Authority table to manage relevant statutes, and the Document table to store responsive records—all without creating a single new table. A grants management portal could rely on Account and Agreement for grantee relationships, Fiscal Period for reporting cycles, and Risk Item for tracking potential program issues. Even workforce planning tools can take advantage of Job Series, Grade-Rank, Competency, and Clearance Level to deliver a complete staffing view without reinventing core HR structures.

By providing this reusable set of well-designed tables and relationships, the Government Data Models – Core module does more than accelerate development. It creates a foundation that agencies can trust, knowing that the data is structured for compliance, interoperability, and future reuse. In short, it’s the common language for the many solutions that together make up a modern government’s digital ecosystem.

# Entity Relationship Diagram and Data Dictionary

An ERD (Entity Relationship Diagram) and data dictionary are available [here](docs/erd.md).

# Releases

We highly recommend using the managed versions, which will allow you to easily update and uninstall the solution from your environment. If you need to modify or enhance the managed solution, you can can create a new solution, add the components to that solution and make changes as needed.

  - [Gov Data Models - Core](releases)