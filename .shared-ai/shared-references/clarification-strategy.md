# Clarification Strategy

When you encounter missing, ambiguous, or contradictory information while processing documents, you must pause and prompt the user for clarification using a specific multiple-choice format.

## Prompting Procedure

When clarification is needed, always follow these rules:

1.  **Identify the Issue**: Clearly state what information is missing, ambiguous, or contradictory.
2.  **Formulate Options**: Provide between **3 and 5** distinct choices for resolving the issue.
    *   The choices should cover the most likely scenarios based on the context.
    *   The final option must always be an "Other (please specify)" or "Free text input" choice, allowing the user to provide a custom answer.
3.  **Provide a Recommendation**:
    *   Explicitly state which of the options you recommend.
    *   Provide a brief justification for why you are recommending this option.
    *   Include a sense of your confidence in this recommendation (e.g., "High Confidence: The surrounding documents strongly suggest...", or "Low Confidence: I'm recommending this based on standard industry practices, but the documents are silent on this point.").

**Note for Tool Usage:** If you have an interactive `ask_user` tool available, use its multiple-choice capabilities to present this to the user. Otherwise, present it clearly as formatted text and stop execution to wait for their reply.