# Release 1.0.2.0 (Jun-06, 2025)

-   **Added Analysis Table, with Lookup to Legal Authority Table:**  
    - A new **Analysis table** has been introduced to support structured evaluation and assessment activities within the system. This table is designed to capture in-depth evaluations related to **Operational Events, Directives, Executive Orders (EOs), or other entities**. By including a **lookup to the Legal Authority table**, the Analysis table can directly reference **Executive Orders and other legal mandates**, allowing users to assess the impact or compliance of these legal instruments. This enhancement facilitates **systematic analysis, decision-making, and reporting** across various agency activities.
    
-   **Added Impact Table, with Lookup to Analysis Table:**  
    - The new **Impact table** has been created to capture the **measured effects or results** of actions, events, or initiatives. Each impact record is linked to an **Analysis record** to maintain a clear relationship between the **evaluation process** and the **quantifiable or qualitative outcomes**. This structured approach enables agencies to **track realized benefits, cost reductions, readiness improvements, and compliance outcomes** stemming from specific analyses. Additionally, the Impact table supports **both pre-event (anticipated impacts)** and **post-event (realized impacts)**, enhancing the ability to evaluate agency performance.
    
-   **Added Analysis Lookup to Risk Items:**  
    - To strengthen the connection between **risk management and impact analysis**, the **Risk Item table** now includes a **lookup to the Analysis table**. This relationship enables users to document **how identified risks have been assessed**, including the **methods used, risk mitigation strategies, and the outcomes** of risk management efforts. By linking risks to analyses, agencies can **track the effectiveness of risk reduction efforts** and **evaluate residual risks** after mitigation. This enhancement supports a more **integrated approach to risk and impact management**, providing comprehensive insights into how risks evolve into measurable impacts.

-  **Icons**
    - Added icons to Legal Authority and Analysis tables.

-  **Risk Item**
    - Added lookup to Organization Unit, to track which organization unit (component) the risk applies to. Added icon to Risk Item.

-  **New Choice Fields**
    - Added Severity Level, Impact; Added Mixed and Uncertain to Polarity choice.