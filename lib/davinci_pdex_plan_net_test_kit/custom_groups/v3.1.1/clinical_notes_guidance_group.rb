# coding: utf-8
require_relative '../clinical_note_attachment_test'
require_relative '../clinical_note_type_test'

module DaVinciPDEXPlanNetTestKit
  module USCoreV311
    class ClinicalNotesGuidanceGroup < Inferno::TestGroup
      id :us_core_v311_clinical_notes_guidance
      title 'Clinical Notes Guidance'
      short_description 'Verify DiagnosticReport and DocumentReference resources support the US Core Clinical Notes Guidance.'
      description %(
        The #{title} Sequence tests DiagnosticReport and DocumentReference
        resources associated with the provided patient. The resources returned
        will be checked for consistency against the [US Core Clinical Notes
        Guidance](https://hl7.org/fhir/us/core/STU3.1.1/clinical-notes-guidance.html)

        In this set of tests, Inferno serves as a FHIR client that attempts to
        access the different types of Clinical Notes specified in the guidance.
        The provided patient needs to have the following five common clinical
        notes as DocumentReference resources:

        * Consultation Note (11488-4)
        * Discharge Summary (18842-5)
        * History & Physical Note (34117-2)
        * Procedures Note (28570-0)
        * Progress Note (11506-3)

        The provided patient also needs to have the following three common
        diagnostic reports as DiagnosticReport resources:

        * Cardiology (LP29708-2)
        * Pathology (LP7839-6)
        * Radiology (LP29684-5)

        In order to enable consistent access to scanned narrative-only clinical
        reports, the US Core server shall expose these reports through both
        DiagnosticReport and DocumentReference by representing the same attachment
        url.
      )
      run_as_group

      test from: :us_core_clinical_note_types do
       config(
        options: { required_types: ['11488-4', '18842-5', '34117-2', '28570-0', '11506-3'].freeze }
       )
      end

      test from: :us_core_clinical_note_attachments
    end
  end
end
