import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { NoticeBox } from '../components';
import { Window } from '../layouts';
import { LaunchpadControl } from './LaunchpadConsole';

type Data = {
  has_pad: BooleanLike;
  pad_closed: BooleanLike;
};

export const LaunchpadRemote = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { has_pad, pad_closed } = data;

  return (
    <Window
      title="Briefcase Launchpad Remote"
      width={300}
      height={240}
      theme="syndicate"
    >
      <Window.Content>
        {(!has_pad && <NoticeBox>No Launchpad Connected</NoticeBox>) ||
          (pad_closed && <NoticeBox>Launchpad Closed</NoticeBox>) || (
            <LaunchpadControl topLevel />
          )}
      </Window.Content>
    </Window>
  );
};
