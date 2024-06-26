import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  satellites: Satellite[];
  meteor_shield: BooleanLike;
  meteor_shield_coverage: number;
  meteor_shield_coverage_max: number;
};

type Satellite = {
  id: string;
  active: BooleanLike;
  mode: string;
};

export const SatelliteControl = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { meteor_shield } = data;

  return (
    <Window width={400} height={305}>
      <Window.Content>
        {meteor_shield && <ShieldInfo />}
        <SatelliteDisplay />
      </Window.Content>
    </Window>
  );
};

/** Displays coverage info of the meteor shield */
const ShieldInfo = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { meteor_shield_coverage, meteor_shield_coverage_max } = data;

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Покрытие">
          <ProgressBar
            value={meteor_shield_coverage / meteor_shield_coverage_max}
            content={
              (100 * meteor_shield_coverage) / meteor_shield_coverage_max + '%'
            }
            ranges={{
              good: [1, Infinity],
              average: [0.3, 1],
              bad: [-Infinity, 0.3],
            }}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

/** Displays a map of satellites and their status */
const SatelliteDisplay = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { satellites = [] } = data;

  return (
    <Section title="Управление">
      <Box mr={-1}>
        {satellites.map((satellite) => (
          <Button.Checkbox
            key={satellite.id}
            checked={satellite.active}
            content={'#' + satellite.id + ' ' + satellite.mode}
            onClick={() =>
              act('toggle', {
                id: satellite.id,
              })
            }
          />
        ))}
      </Box>
    </Section>
  );
};
