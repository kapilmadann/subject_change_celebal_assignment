# subject_change_celebal_assignment
🎓 College Open Elective Subject Tracking – Weekly Assignment 5
Author: Kapil Madan

📷 Output
![image](https://github.com/user-attachments/assets/299502c1-6500-4f2d-82a7-cf72ffe8e2a0)


📄 Assignment Overview
This was my fifth weekly assignment during my internship. The task involved developing a system to manage and monitor students' open elective subject choices within a college database.

Colleges allow students to change their electives at the beginning of the academic year. The system needed to retain the full history of these changes while indicating which subject is currently active for each student.

🔍 Problem Statement
Students may submit requests to change their elective subjects.

The college requires a complete history of all subject selections, not just the most recent one.

The data is maintained in two tables:

SubjectAllotments
Tracks all past and current subject assignments:

StudentId: Unique student identifier

SubjectId: Elective subject code

Is_Valid: A flag indicating if the subject is currently active (1) or historical (0)

SubjectRequest
Holds new elective change requests:

StudentId: Unique student identifier

SubjectId: Desired elective subject code

🧠 Business Rules
If a student doesn't exist in SubjectAllotments, insert the requested subject as active.

If a student has a different active subject, mark the current one as inactive and insert the new one as active.

If the requested subject is already active, no changes are made.

The objective is to ensure only one active subject per student, while maintaining a full record of changes.

💻 Tech Stack
Database: Microsoft SQL Server

🏗️ Tables Used
1. SubjectAllotments
Stores subject choices along with their status (active/inactive).

Column	Type	Description
StudentId	VARCHAR	Student's ID
SubjectId	VARCHAR	Code of the elective subject
Is_Valid	BIT	1 for active, 0 for inactive

2. SubjectRequest
Stores incoming change requests.

Column	Type	Description
StudentId	VARCHAR	Student's ID
SubjectId	VARCHAR	Requested elective subject

🛠️ Solution Design
A stored procedure was created in T-SQL to process the requests in the SubjectRequest table.

Steps followed:

For each student:

If no active subject is found, insert the new subject as active.

If a different subject is active, update it to inactive and insert the new one as active.

If the requested subject is already active, skip the update.

This ensures:

Only one active subject per student.

Full history is maintained.

✅ Usage Guide
Create SubjectAllotments and SubjectRequest tables if they don’t already exist.

Add sample data to both tables.

Run the stored procedure ProcessSubjectRequests.

Review the SubjectAllotments table to confirm:

New students were added correctly.

Subject switches are updated with old ones marked inactive.

No redundant records exist.

📌 Example Scenario
Before Processing:

SubjectAllotments

StudentId	SubjectId	Is_Valid
159103036	PO1491	1
159103036	PO1492	0

SubjectRequest

StudentId	SubjectId
159103036	PO1496

After Processing:

StudentId	SubjectId	Is_Valid
159103036	PO1496	1
159103036	PO1491	0
159103036	PO1492	0

📝 Final Notes
Automatically handles requests from new students.

Keeps a historical record for auditing.

Enforces the rule of one active subject per student at any given time.
