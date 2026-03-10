// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
import { Construct } from 'constructs';
import { ControlRunbookDocument, ControlRunbookProps, RemediationScope } from './control_runbook';
import { PlaybookProps } from '../lib/control_runbooks-construct';
import { AutomationStep, DataTypeEnum, HardCodedString, Output, StringVariable } from '@cdklabs/cdk-ssm-documents';

export function createControlRunbook(scope: Construct, id: string, props: PlaybookProps): ControlRunbookDocument {
  return new ConfigureS3BucketVersioningDocument(scope, id, { ...props, controlId: 'S3.14' });
}

class ConfigureS3BucketVersioningDocument extends ControlRunbookDocument {
  constructor(scope: Construct, id: string, props: ControlRunbookProps) {
    super(scope, id, {
      ...props,
      securityControlId: 'S3.14',
      remediationName: 'ConfigureS3BucketVersioning',
      scope: RemediationScope.GLOBAL,
      resourceIdName: 'BucketName',
      resourceIdRegex: String.raw`^arn:(?:aws|aws-cn|aws-us-gov):s3:::([a-z0-9](?:[a-z0-9.-]{1,61}[a-z0-9])?)$`,
      updateDescription: HardCodedString.of('This document configures versioning for an Amazon Simple Storage Service (Amazon S3) bucket.'),
    });
  }

  protected override getExtraSteps(): AutomationStep[] {
    return [
      super.getInputParamsStep({
        versioningState: 'Enabled',
      }),
    ];
  }

  protected override getInputParamsStepOutput(): Output[] {
    return [{
      name: 'versioningState',
      outputType: DataTypeEnum.STRING,
      selector: '$.Payload.versioningState',
    }];
  }

  protected override getRemediationParams():  Record<string, any> {
    const params: Record<string, any> = super.getRemediationParams();

    params.BucketName = StringVariable.of('ParseInput.BucketName');
    params.VersioningState = StringVariable.of('GetInputParams.versioningState');

    return params;
  }
}
