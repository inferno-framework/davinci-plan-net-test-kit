Practitioner:
- _has:PractitionerRole:practitioner:location
- _has:PractitionerRole:practitioner:network
- _has:PractitionerRole:practitioner:speciality
- _has:PractitionerRole:practitioner:role

Organization:
- _has:OrganizationAffiliation:participating-organization:location
- _has:OrganizationAffiliation:participating-organization:network
- _has:OrganizationAffiliation:participating-organization:speciality
- _has:InsurancePlan:owned-by:coverage-area

Location:
- _has:InsurancePlan:coverage-area:owned-by

Network:
- _has:PractitionerRole:network:location