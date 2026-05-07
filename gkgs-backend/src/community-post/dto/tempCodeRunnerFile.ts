export class CreateCommunityPostDto {
  userId: string;
  type: string;
  content: string;
  isAnon?: boolean;
}