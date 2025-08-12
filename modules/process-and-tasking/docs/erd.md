# Government Data Models - Process and Tasking

# Entity Relationship Diagram

```mermaid
graph TD
  Contact(Person)
  govcdm_ActionAssignment(Action Assignment)
  govcdm_ActionCategory(Action Category)
  govcdm_ActionItem(Action Item)
  govcdm_CollaborationSpace(Collaboration Space)
  govcdm_ContentTemplate(Content Template)
  govcdm_DataEntryResponse(Data Entry Response)
  govcdm_DataEntryStep(Data Entry Step)
  govcdm_DataForm(Data Form)
  govcdm_DiscussionItem(Discussion Item)
  govcdm_Document(Document)
  govcdm_InteractivePrompt(Interactive Prompt)
  govcdm_InteractivePromptChoice(Interactive Prompt Choice)
  govcdm_InteractivePromptChoiceOption(Interactive Prompt Choice Option)
  govcdm_InteractiveResponse(Interactive Response)
  govcdm_ProcessStep(Process Step)
  govcdm_ProcessStepDependency(Process Step Dependency)
  govcdm_ProcessStepTool(Process Step Tool)
  govcdm_SignatureApproval(Signature Approval)
  SystemUser(User)
  govcdm_ActionAssignment --> Account
  govcdm_ActionItem --> Account
  govcdm_ActionAssignment --> ActivityPointer
  govcdm_ActionItem --> ActivityPointer
  govcdm_ActionAssignment --> adx_invitation
  govcdm_ActionItem --> adx_invitation
  govcdm_ActionAssignment --> Contact
  govcdm_ActionItem --> Contact
  govcdm_ActionItem --> Contact
  govcdm_DataEntryResponse --> Contact
  govcdm_InteractiveResponse --> Contact
  govcdm_DataEntryResponse --> FileAttachment
  govcdm_InteractiveResponse --> FileAttachment
  govcdm_CollaborationSpace --> govcdm_ActionAssignment
  govcdm_DiscussionItem --> govcdm_ActionAssignment
  govcdm_Document --> govcdm_ActionAssignment
  govcdm_ActionAssignment --> govcdm_ActionAssignment
  govcdm_ActionCategory --> govcdm_ActionCategory
  govcdm_ActionItem --> govcdm_ActionCategory
  govcdm_ActionItem --> govcdm_ActionCategory
  govcdm_ActionItem --> govcdm_ActionItem
  govcdm_ActionItem --> govcdm_ActionItem
  govcdm_CollaborationSpace --> govcdm_ActionItem
  govcdm_DiscussionItem --> govcdm_ActionItem
  govcdm_Document --> govcdm_ActionItem
  govcdm_ProcessStep --> govcdm_CollaborationSpace
  govcdm_ProcessStep --> govcdm_ContentTemplate
  govcdm_ProcessStepTool --> govcdm_ContentTemplate
  govcdm_ActionAssignment --> govcdm_DataEntryResponse
  govcdm_ActionItem --> govcdm_DataEntryResponse
  govcdm_DataEntryResponse --> govcdm_DataEntryResponse
  govcdm_DataEntryResponse --> govcdm_DataEntryStep
  govcdm_DataEntryStep --> govcdm_DataEntryStep
  govcdm_ProcessStep --> govcdm_DataEntryStep
  govcdm_ProcessStep --> govcdm_DataForm
  govcdm_ActionAssignment --> govcdm_Document
  govcdm_ActionItem --> govcdm_Document
  govcdm_InteractivePrompt --> govcdm_InteractivePrompt
  govcdm_InteractiveResponse --> govcdm_InteractivePrompt
  govcdm_InteractivePrompt --> govcdm_InteractivePromptChoice
  govcdm_InteractivePromptChoiceOption --> govcdm_InteractivePromptChoice
  govcdm_InteractiveResponse --> govcdm_InteractiveResponse
  govcdm_ActionItem --> govcdm_ProcessStep
  govcdm_ActionAssignment --> govcdm_ProcessStep
  govcdm_ProcessStep --> govcdm_ProcessStep
  govcdm_ProcessStep --> govcdm_ProcessStep
  govcdm_ProcessStep --> govcdm_ProcessStep
  govcdm_ProcessStepDependency --> govcdm_ProcessStep
  govcdm_ProcessStepDependency --> govcdm_ProcessStep
  govcdm_ProcessStepTool --> govcdm_ProcessStep
  govcdm_ActionItem --> govcdm_SignatureApproval
  govcdm_ActionAssignment --> govcdm_SignatureApproval
  govcdm_ActionAssignment --> InteractionForEmail
  govcdm_ActionItem --> InteractionForEmail
  govcdm_ActionAssignment --> KnowledgeArticle
  govcdm_ActionItem --> KnowledgeArticle
  govcdm_ActionAssignment --> KnowledgeBaseRecord
  govcdm_ActionItem --> KnowledgeBaseRecord
  govcdm_ActionAssignment --> Mailbox
  govcdm_ActionItem --> Mailbox
  govcdm_ActionAssignment --> mspp_adplacement
  govcdm_ActionItem --> mspp_adplacement
  govcdm_ActionAssignment --> mspp_pollplacement
  govcdm_ActionItem --> mspp_pollplacement
  govcdm_ActionAssignment --> mspp_publishingstatetransitionrule
  govcdm_ActionItem --> mspp_publishingstatetransitionrule
  govcdm_ActionAssignment --> mspp_redirect
  govcdm_ActionItem --> mspp_redirect
  govcdm_ActionAssignment --> mspp_shortcut
  govcdm_ActionItem --> mspp_shortcut
  govcdm_ActionAssignment --> mspp_website
  govcdm_ActionItem --> mspp_website
  govcdm_ActionAssignment --> SLA
  govcdm_ActionAssignment --> SLA
  govcdm_ActionItem --> SLA
  govcdm_ActionItem --> SLA

```

# Person

**Metadata**

- Schema: Contact

**Custom Fields**

# Action Assignment

**Metadata**

- Schema: govcdm_ActionAssignment

**Custom Fields**

- (Deprecated) Process Stage
  - Type: Uniqueidentifier
  - Schema: StageId
- (Deprecated) Traversed Path
  - Type: Nvarchar
  - Schema: TraversedPath
- Action Status
  - Type: Picklist
  - Schema: govcdm_ActionStatus
- Action Type
  - Type: Picklist
  - Schema: govcdm_ActionType
- Activity Additional Parameters
  - Type: Ntext
  - Schema: ActivityAdditionalParams
- Activity Status
  - Type: State
  - Schema: StateCode
- Activity Type
  - Type: Picklist
  - Schema: ActivityTypeCode
- Actual Duration
  - Type: Int
  - Schema: ActualDurationMinutes
- Actual End
  - Type: Datetime
  - Schema: ActualEnd
- Actual Start
  - Type: Datetime
  - Schema: ActualStart
- Automation Response
  - Type: Ntext
  - Schema: govcdm_AutomationResponse
- Automation Triggered Date Time
  - Type: Datetime
  - Schema: govcdm_AutomationTriggeredDateTime
- BCC
  - Type: Partylist
  - Schema: BCC
- CC
  - Type: Partylist
  - Schema: CC
- Collaboration URL
  - Type: Nvarchar
  - Schema: govcdm_CollaborationURL
- Customers
  - Type: Partylist
  - Schema: Customers
- Data Entry Response
  - Type: Lookup
  - Schema: govcdm_DataEntryResponse
- Date Delivery Last Attempted
  - Type: Datetime
  - Schema: DeliveryLastAttemptedOn
- Date Sent
  - Type: Datetime
  - Schema: SentOn
- Delay activity processing until
  - Type: Datetime
  - Schema: PostponeActivityProcessingUntil
- Delivery Priority
  - Type: Picklist
  - Schema: DeliveryPriorityCode
- Description
  - Type: Ntext
  - Schema: Description
- Document
  - Type: Lookup
  - Schema: govcdm_Document
- Due Date
  - Type: Datetime
  - Schema: ScheduledEnd
- Exchange Item ID
  - Type: Nvarchar
  - Schema: ExchangeItemId
- Exchange WebLink
  - Type: Nvarchar
  - Schema: ExchangeWebLink
- From
  - Type: Partylist
  - Schema: From
- Is Billed
  - Type: Bit
  - Schema: IsBilled
- Is Paused
  - Type: Picklist
  - Schema: govcdm_IsPaused
- Is Private
  - Type: Bit
  - Schema: IsMapiPrivate
- Is Regular Activity
  - Type: Bit
  - Schema: IsRegularActivity
- Is Workflow Created
  - Type: Bit
  - Schema: IsWorkflowCreated
- Last On Hold Time
  - Type: Datetime
  - Schema: LastOnHoldTime
- Last SLA applied
  - Type: Lookup
  - Schema: SLAInvokedId
- Left Voice Mail
  - Type: Bit
  - Schema: LeftVoiceMail
- On Hold Time (Minutes)
  - Type: Int
  - Schema: OnHoldTime
- Optional Attendees
  - Type: Partylist
  - Schema: OptionalAttendees
- Organizer
  - Type: Partylist
  - Schema: Organizer
- Originator
  - Type: Lookup
  - Schema: govcdm_Originator
- Originator Comments
  - Type: Ntext
  - Schema: govcdm_OriginatorComments
- Outsource Vendors
  - Type: Partylist
  - Schema: Partners
- Parent Action Assignment
  - Type: Lookup
  - Schema: govcdm_ParentActionAssignment
- Priority
  - Type: Picklist
  - Schema: PriorityCode
- Process
  - Type: Uniqueidentifier
  - Schema: ProcessId
- Process Step
  - Type: Lookup
  - Schema: govcdm_ProcessStep
- Recurring Instance Type
  - Type: Picklist
  - Schema: InstanceTypeCode
- Regarding
  - Type: Lookup
  - Schema: RegardingObjectId
- Required Attendees
  - Type: Partylist
  - Schema: RequiredAttendees
- Resources
  - Type: Partylist
  - Schema: Resources
- SLA
  - Type: Lookup
  - Schema: SLAId
- Scheduled Duration
  - Type: Int
  - Schema: ScheduledDurationMinutes
- Sender's Mailbox
  - Type: Lookup
  - Schema: SenderMailboxId
- Series Id
  - Type: Uniqueidentifier
  - Schema: SeriesId
- Signature Approval
  - Type: Lookup
  - Schema: govcdm_SignatureApproval
- Social Channel
  - Type: Picklist
  - Schema: Community
- Sort Date
  - Type: Datetime
  - Schema: SortDate
- Start Date
  - Type: Datetime
  - Schema: ScheduledStart
- Status Reason
  - Type: Status
  - Schema: StatusCode
- Subject
  - Type: Nvarchar
  - Schema: Subject
- To
  - Type: Partylist
  - Schema: To
- Virtual Regarding ID
  - Type: Nvarchar
  - Schema: govcdm_VirtualRegardingID
- Virtual Regarding Type
  - Type: Nvarchar
  - Schema: govcdm_VirtualRegardingType

# Action Category

**Metadata**

- Schema: govcdm_ActionCategory

**Custom Fields**

- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Action Category
  - Type: Lookup
  - Schema: govcdm_ParentActionCategory

# Action Item

**Metadata**

- Schema: govcdm_ActionItem

**Custom Fields**

- (Deprecated) Process Stage
  - Type: Uniqueidentifier
  - Schema: StageId
- (Deprecated) Traversed Path
  - Type: Nvarchar
  - Schema: TraversedPath
- Action Category
  - Type: Lookup
  - Schema: govcdm_ActionCategory
- Action Status
  - Type: Picklist
  - Schema: govcdm_ActionStatus
- Action Subcategory
  - Type: Lookup
  - Schema: govcdm_ActionSubcategory
- Action Type
  - Type: Picklist
  - Schema: govcdm_ActionType
- Activity Additional Parameters
  - Type: Ntext
  - Schema: ActivityAdditionalParams
- Activity Status
  - Type: State
  - Schema: StateCode
- Activity Type
  - Type: Picklist
  - Schema: ActivityTypeCode
- Actual Duration
  - Type: Int
  - Schema: ActualDurationMinutes
- Actual End
  - Type: Datetime
  - Schema: ActualEnd
- Actual Start
  - Type: Datetime
  - Schema: ActualStart
- Automation Response
  - Type: Ntext
  - Schema: govcdm_AutomationResponse
- Automation Triggered Date Time
  - Type: Datetime
  - Schema: govcdm_AutomationTriggeredDateTime
- BCC
  - Type: Partylist
  - Schema: BCC
- CC
  - Type: Partylist
  - Schema: CC
- Collaboration URL
  - Type: Nvarchar
  - Schema: govcdm_CollaborationURL
- Customers
  - Type: Partylist
  - Schema: Customers
- Data Entry Response
  - Type: Lookup
  - Schema: govcdm_DataEntryResponse
- Date Delivery Last Attempted
  - Type: Datetime
  - Schema: DeliveryLastAttemptedOn
- Date Sent
  - Type: Datetime
  - Schema: SentOn
- Delay activity processing until
  - Type: Datetime
  - Schema: PostponeActivityProcessingUntil
- Delivery Priority
  - Type: Picklist
  - Schema: DeliveryPriorityCode
- Description
  - Type: Ntext
  - Schema: Description
- Details
  - Type: Ntext
  - Schema: govcdm_Details
- Document
  - Type: Lookup
  - Schema: govcdm_Document
- Due Date
  - Type: Datetime
  - Schema: ScheduledEnd
- Exchange Item ID
  - Type: Nvarchar
  - Schema: ExchangeItemId
- Exchange WebLink
  - Type: Nvarchar
  - Schema: ExchangeWebLink
- From
  - Type: Partylist
  - Schema: From
- Is Billed
  - Type: Bit
  - Schema: IsBilled
- Is Paused
  - Type: Picklist
  - Schema: govcdm_IsPaused
- Is Private
  - Type: Bit
  - Schema: IsMapiPrivate
- Is Regular Activity
  - Type: Bit
  - Schema: IsRegularActivity
- Is Workflow Created
  - Type: Bit
  - Schema: IsWorkflowCreated
- Last On Hold Time
  - Type: Datetime
  - Schema: LastOnHoldTime
- Last SLA applied
  - Type: Lookup
  - Schema: SLAInvokedId
- Left Voice Mail
  - Type: Bit
  - Schema: LeftVoiceMail
- Next Steps
  - Type: Ntext
  - Schema: govcdm_NextSteps
- On Hold Time (Minutes)
  - Type: Int
  - Schema: OnHoldTime
- Optional Attendees
  - Type: Partylist
  - Schema: OptionalAttendees
- Organizer
  - Type: Partylist
  - Schema: Organizer
- Originator (Person)
  - Type: Lookup
  - Schema: govcdm_OriginatorPerson
- Originator (User)
  - Type: Lookup
  - Schema: govcdm_OriginatorUser
- Originator Comments
  - Type: Ntext
  - Schema: govcdm_OriginatorComments
- Outsource Vendors
  - Type: Partylist
  - Schema: Partners
- Parent Action Item
  - Type: Lookup
  - Schema: govcdm_ParentActionItem
- Primary Action Item
  - Type: Lookup
  - Schema: govcdm_PrimaryActionItem
- Priority
  - Type: Picklist
  - Schema: PriorityCode
- Process
  - Type: Uniqueidentifier
  - Schema: ProcessId
- Process Step
  - Type: Lookup
  - Schema: govcdm_ProcessStep
- Recurring Instance Type
  - Type: Picklist
  - Schema: InstanceTypeCode
- Regarding
  - Type: Lookup
  - Schema: RegardingObjectId
- Required Attendees
  - Type: Partylist
  - Schema: RequiredAttendees
- Resources
  - Type: Partylist
  - Schema: Resources
- SLA
  - Type: Lookup
  - Schema: SLAId
- Scheduled Duration
  - Type: Int
  - Schema: ScheduledDurationMinutes
- Sender's Mailbox
  - Type: Lookup
  - Schema: SenderMailboxId
- Series Id
  - Type: Uniqueidentifier
  - Schema: SeriesId
- Signature Approval
  - Type: Lookup
  - Schema: govcdm_SignatureApproval
- Social Channel
  - Type: Picklist
  - Schema: Community
- Sort Date
  - Type: Datetime
  - Schema: SortDate
- Start Date
  - Type: Datetime
  - Schema: ScheduledStart
- Status Reason
  - Type: Status
  - Schema: StatusCode
- Subject
  - Type: Nvarchar
  - Schema: Subject
- Tags
  - Type: Ntext
  - Schema: govcdm_Tags
- To
  - Type: Partylist
  - Schema: To
- Virtual Regarding ID
  - Type: Nvarchar
  - Schema: govcdm_VirtualRegardingID
- Virtual Regarding Type
  - Type: Nvarchar
  - Schema: govcdm_VirtualRegardingType

# Collaboration Space

**Metadata**

- Schema: govcdm_CollaborationSpace

**Custom Fields**

- Action Assignment
  - Type: Lookup
  - Schema: govcdm_ActionAssignment
- Action Item
  - Type: Lookup
  - Schema: govcdm_ActionItem
- Collaboration Space Type
  - Type: Picklist
  - Schema: govcdm_CollaborationSpaceType
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- SharePoint Folder Path
  - Type: Nvarchar
  - Schema: govcdm_SharePointFolderPath
- SharePoint Site
  - Type: Nvarchar
  - Schema: govcdm_SharePointSite
- Team Channel ID
  - Type: Nvarchar
  - Schema: govcdm_TeamChannelID
- Team Chat ID
  - Type: Nvarchar
  - Schema: govcdm_TeamChatID
- Team ID
  - Type: Nvarchar
  - Schema: govcdm_TeamID
- URL
  - Type: Nvarchar
  - Schema: govcdm_URL
- Virtual Record Display Field
  - Type: Nvarchar
  - Schema: govcdm_VirtualRecordDisplayField
- Virtual Record ID
  - Type: Nvarchar
  - Schema: govcdm_VirtualRecordID
- Virtual Record Type
  - Type: Nvarchar
  - Schema: govcdm_VirtualRecordType

# Content Template

**Metadata**

- Schema: govcdm_ContentTemplate

**Custom Fields**

- SharePoint File Path
  - Type: Nvarchar
  - Schema: govcdm_SharePointFilePath
- SharePoint Site
  - Type: Nvarchar
  - Schema: govcdm_SharePointSite

# Data Entry Response

**Metadata**

- Schema: govcdm_DataEntryResponse

**Custom Fields**

- Data Entry Step
  - Type: Lookup
  - Schema: govcdm_DataEntryStep
- Data Entry Type
  - Type: Picklist
  - Schema: govcdm_DataEntryType
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Data Entry Reponse
  - Type: Lookup
  - Schema: govcdm_ParentDataEntryReponse
- Responder
  - Type: Lookup
  - Schema: govcdm_Responder
- Response Date
  - Type: Datetime
  - Schema: govcdm_ResponseDate
- Response Date Time
  - Type: Datetime
  - Schema: govcdm_ResponseDateTime
- Response File
  - Type: File
  - Schema: govcdm_ResponseFile
- Response Float
  - Type: Float
  - Schema: govcdm_ResponseFloat
- Response Image
  - Type: Image
  - Schema: govcdm_ResponseImage
- Response Long Text
  - Type: Ntext
  - Schema: govcdm_ResponseLongText
- Response Short Text
  - Type: Nvarchar
  - Schema: govcdm_ResponseShortText
- Response Whole Number
  - Type: Int
  - Schema: govcdm_ResponseWholeNumber

# Data Entry Step

**Metadata**

- Schema: govcdm_DataEntryStep

**Custom Fields**

- App Name
  - Type: Nvarchar
  - Schema: govcdm_AppName
- Data Entry Step Order
  - Type: Int
  - Schema: govcdm_DataEntryStepOrder
- Data Entry Type
  - Type: Picklist
  - Schema: govcdm_DataEntryType
- Description
  - Type: Ntext
  - Schema: govcdm_Description
- Form Applies to Schema Name
  - Type: Nvarchar
  - Schema: govcdm_FormAppliestoSchemaName
- Form Base URL
  - Type: Nvarchar
  - Schema: govcdm_FormBaseURL
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Data Entry Step
  - Type: Lookup
  - Schema: govcdm_ParentDataEntryStep
- Valid for Create
  - Type: Picklist
  - Schema: govcdm_ValidforCreate

# Data Form

**Metadata**

- Schema: govcdm_DataForm

**Custom Fields**

- Base URL
  - Type: Nvarchar
  - Schema: govcdm_BaseURL
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Schema Name
  - Type: Nvarchar
  - Schema: govcdm_SchemaName
- Valid for Create
  - Type: Picklist
  - Schema: govcdm_ValidforCreate

# Discussion Item

**Metadata**

- Schema: govcdm_DiscussionItem

**Custom Fields**

- Action Assignment
  - Type: Lookup
  - Schema: govcdm_ActionAssignment
- Action Item
  - Type: Lookup
  - Schema: govcdm_ActionItem

# Document

**Metadata**

- Schema: govcdm_Document

**Custom Fields**

- Action Assignment
  - Type: Lookup
  - Schema: govcdm_ActionAssignment
- Action Item
  - Type: Lookup
  - Schema: govcdm_ActionItem

# Interactive Prompt

**Metadata**

- Schema: govcdm_InteractivePrompt

**Custom Fields**

- Details
  - Type: Ntext
  - Schema: govcdm_Details
- Interactive Prompt Choice
  - Type: Lookup
  - Schema: govcdm_InteractivePromptChoice
- Interactive Prompt Type
  - Type: Picklist
  - Schema: govcdm_InteractivePromptType
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Interactive Prompt
  - Type: Lookup
  - Schema: govcdm_ParentInteractivePrompt
- Prompt
  - Type: Nvarchar
  - Schema: govcdm_Prompt

# Interactive Prompt Choice

**Metadata**

- Schema: govcdm_InteractivePromptChoice

**Custom Fields**

- Name
  - Type: Nvarchar
  - Schema: govcdm_Name

# Interactive Prompt Choice Option

**Metadata**

- Schema: govcdm_InteractivePromptChoiceOption

**Custom Fields**

- Interactive Prompt Choice
  - Type: Lookup
  - Schema: govcdm_InteractivePromptChoice
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name

# Interactive Response

**Metadata**

- Schema: govcdm_InteractiveResponse

**Custom Fields**

- Interactive Prompt
  - Type: Lookup
  - Schema: govcdm_InteractivePrompt
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Interactive Response
  - Type: Lookup
  - Schema: govcdm_ParentInteractiveResponse
- Responder
  - Type: Lookup
  - Schema: govcdm_Responder
- Response Date Time
  - Type: Datetime
  - Schema: govcdm_ResponseDateTime
- Response File
  - Type: File
  - Schema: govcdm_ResponseFile
- Response Float
  - Type: Float
  - Schema: govcdm_ResponseFloat
- Response Image
  - Type: Image
  - Schema: govcdm_ResponseImage
- Response Long Text
  - Type: Ntext
  - Schema: govcdm_ResponseLongText
- Response Short Text
  - Type: Nvarchar
  - Schema: govcdm_ResponseShortText
- Response Whole Number
  - Type: Int
  - Schema: govcdm_ResponseWholeNumber

# Process Step

**Metadata**

- Schema: govcdm_ProcessStep

**Custom Fields**

- Assign To
  - Type: Picklist
  - Schema: govcdm_AssignTo
- Collaboration Space
  - Type: Lookup
  - Schema: govcdm_CollaborationSpace
- Content Template
  - Type: Lookup
  - Schema: govcdm_ContentTemplate
- Data Entry Step
  - Type: Lookup
  - Schema: govcdm_DataEntryStep
- Data Form
  - Type: Lookup
  - Schema: govcdm_DataForm
- Details
  - Type: Ntext
  - Schema: govcdm_Details
- Due Date Calc Method
  - Type: Picklist
  - Schema: govcdm_DueDateCalcMethod
- Due Date Offset
  - Type: Int
  - Schema: govcdm_DueDateOffset
- Enable Submission Info
  - Type: Picklist
  - Schema: govcdm_EnableSubmissionInfo
- Main Process Step
  - Type: Lookup
  - Schema: govcdm_MainProcessStep
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Parent Process Step
  - Type: Lookup
  - Schema: govcdm_ParentProcessStep
- Primary Process Step
  - Type: Lookup
  - Schema: govcdm_PrimaryProcessStep
- Primary Record Display Field
  - Type: Nvarchar
  - Schema: govcdm_PrimaryRecordDisplayField
- Process Step Order
  - Type: Int
  - Schema: govcdm_ProcessStepOrder
- Process Step Type
  - Type: Picklist
  - Schema: govcdm_ProcessStepType
- Sub Step Processing Order
  - Type: Picklist
  - Schema: govcdm_SubStepProcessingOrder

# Process Step Dependency

**Metadata**

- Schema: govcdm_ProcessStepDependency

**Custom Fields**

- Depends On
  - Type: Lookup
  - Schema: govcdm_DependsOn
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Process Step
  - Type: Lookup
  - Schema: govcdm_ProcessStep

# Process Step Tool

**Metadata**

- Schema: govcdm_ProcessStepTool

**Custom Fields**

- Content Template
  - Type: Lookup
  - Schema: govcdm_ContentTemplate
- Name
  - Type: Nvarchar
  - Schema: govcdm_Name
- Process Step
  - Type: Lookup
  - Schema: govcdm_ProcessStep

# Signature Approval

**Metadata**

- Schema: govcdm_SignatureApproval

**Custom Fields**

# User

**Metadata**

- Schema: SystemUser

**Custom Fields**

