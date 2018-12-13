# Machine Learner 1
## 1. Is it possible to predict who complaints will come in against using a combination of officer information such as age, race, rank and demographics information of the complainants from past reports?

#### Conclusions:
Our initial decision tree algorithm reached a test accuracy of around 79%; it was able to predict whether or not an officer had been subject to a complaint after 2009 with a relatively high accuracy. Interestingly, we found that the first attribute that our decision tree split on was not race or gender, but rather age; an aspect of officer identities that we hadn’t at all considered during our previous checkpoints. It appeared that officers particularly between the age ranges of 37.5 and 47.5 were predicted to be subject to complaints.

In order to connect our predictor to our previous research which centered largely around race and gender, we then decided to remove the ages of the officers from our dataset, and rerun the decision tree. This resulted in a slightly lower test accuracy of around 76%; which seems to suggest that, even without age, race gender and officer position still seem to provide strong predictive power for whether an officer is likely to be subject to a complaint. Here we found that the decision tree now initially split on gender as its first attribute, followed by race. In the case of both this decision tree and the other, it appeared that the status/position of the officer did not provide much information with regards to our question, and was not included as an attribute that was split over.

#### Lessons Learned: 
Overall, it appears that the social location of officers can be used as an effective predictor of whether or not they are likely to be subject to a complaint. One interesting application of this could be to apply such a predictor to the dataset of all officers (who have yet to be subject to a complaint) and to see if over, for example, the next 5 years, the predictions made by the decision tree turn out to correctly identify officers that are ‘set for’ a complaint.


# Machine Learner 2
## 2. Is it possible to predict whether an officer will be the subject of a settlement using the details of their complaint history including frequency of complaints and nature of complaints?

#### Conclusions:
Our decision tree resulted in an accuracy of approximately 82%. The decision tree first chose to split on the number of allegations for each officer and then the categories of complaints. The cases where the learner predicted that the officer would be involved in a settlement were the following: 
If allegation count is greater than 47.5 and the category is Operation/Personnel Violations, Lockup Procedures, False Arrest, Criminal Misconduct or Domestic
If category is Illegal Search and allegation count is between 28.5 and 36.5
If category is Use Of Force and allegation count is between 36.5 and 47.5
If category is Illegal Search, Traffic, Drug/Alcohol Abuse, Bribery/Official Corruption, First Amendment then regardless of count the officer will be involved in a settlement

#### Lessons Learned
Looking at the decision tree that was created, it seems like the tree relied heavily on the number of allegations as opposed to the type of complaint. Previously in checkpoint two, we found that there wasn’t a correlation between the amount that an officer owed in a settlement and the number of complaints an officer was involved in. However, our decision tree seems to rely heavily on the number of allegations to determine whether an officer will be involved in a settlement or not. From this, it seems that how much an officer owes in a settlement and whether an officer will be involved in a settlement are not related by number of allegations. 
